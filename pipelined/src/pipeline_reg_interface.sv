import global_defs_pkg::*;
interface pipeline_intf;

    //  IF_ID Signals
    logic clk, clr, en, reset;
    logic [XLEN-1:0] instrF, PCF, PCPlus4F;
    logic [XLEN-1:0] instrD, PCD, PCPlus4D;

    modport IF_ID (
    input clk, clr, en, reset, 
            instrF, PCF, PCPlus4F,
    output  instrD, PCD, PCPlus4D
    );

    //  ID_EX signals
        //  input signals
    logic           RegWriteD, MemWriteD,
    logic [2:0]     ResultSrcD,
    logic           JumpD, JumpALRD, BranchD,
    logic [3:0]     ALUControlD,
    logic           ALUSrcD,
    logic           op5D,
    
    logic [XLEN-1:0]    RD1D, RD2D, PCD, PCPlus4D, immextD, 
    logic [4:0]         Rs1D, Rs2D, RdD,
    logic [2:0]     funct3D,

        //  ouput signals
    logic          RegWriteE, MemWriteE,
    logic [2:0]    ResultSrcE,
    logic          JumpE, JumpALRE, BranchE,
    logic [3:0]    ALUControlE,
    logic          ALUSrcE,
    logic           op5E,
        
    
    logic [XLEN-1:0]    RD1E, RD2E, PCE, PCPlus4E, immextE,
    logic [4:0]         Rs1E, Rs2E, RdE,
    logic [2:0]     funct3E

    modport ID_EX (
    input clk, clr, reset,
            RegWriteD, MemWriteD, ResultSrcD, JumpD,
            JumpALRD, BranchD, ALUControlD, ALUSrcD, op5D, RD1D, RD2D, PCD, PCPlus4D, immextD,
            Rs1D, Rs2D, RdD,
    output RegWriteE, MemWriteE, ResultSrcE, JumpE, JumpALRE, BranchE, ALUControlE,
            ALUSrcE, op5E, RD1E, RD2E, PCE, PCPlus4E, immextE, RS1E, Rs2E, RdE, funct3E
    );




endinterface //IF_ID_INTF