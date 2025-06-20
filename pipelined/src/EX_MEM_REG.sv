module EX_MEM_REG
    #(parameter XLEN = 32)
    (
        input   logic               clk, reset,
        input   logic               RegWriteE, MemWriteE,
        input   logic [2:0]         ResultSrcE,
        input   logic [XLEN-1:0]    ALUResultE,
        input   logic [XLEN-1:0]    WriteDataE,
        input   logic [4:0]         RdE,
        input   logic [XLEN-1:0]    PCPlus4E, PCTargetE,
        input   logic [2:0]         funct3E,
        input   logic [XLEN-1:0]    ResultUE,
        input   logic [XLEN-1:0]    CSRRegDataE,
        
        output  logic               RegWriteM, MemWriteM,
        output  logic [2:0]         ResultSrcM,
        output  logic [XLEN-1:0]    ALUResultM,
        output  logic [XLEN-1:0]    WriteDataM,
        output  logic [4:0]         RdM,
        output  logic [XLEN-1:0]    PCPlus4M, PCTargetM,
        output  logic [2:0]         funct3M,
        output  logic [XLEN-1:0]    ResultUM,
        output  logic [XLEN-1:0]    CSRRegDataM
    );
    always_ff @(posedge clk, posedge reset)
        if (reset)
            {RegWriteM, MemWriteM, ResultSrcM, ALUResultM, WriteDataM, RdM,
                PCPlus4M, PCTargetM, funct3M, ResultUM,
                CSRRegDataM} <= '0;
        else
            begin
                {RegWriteM, MemWriteM, ResultSrcM, ALUResultM, WriteDataM, RdM,
                PCPlus4M, PCTargetM, funct3M, ResultUM,
                CSRRegDataM} <= {RegWriteE, MemWriteE, 
                ResultSrcE, ALUResultE, WriteDataE, RdE, 
                PCPlus4E, PCTargetE, funct3E, ResultUE,
                CSRRegDataE};
            end
endmodule
