module MEM_WB_REG
    #(parameter XLEN = 32)
    (
        input   logic               clk, reset,
        input   logic               RegWriteM,
        input   logic [4:0]         RdM,
        input   logic [XLEN-1:0]    ResultM,
        output  logic               RegWriteWB,
        output  logic [4:0]         RdWB,
        output  logic [XLEN-1:0]    ResultWB
    );
    always_ff @(posedge clk)
        if (reset)
            {RegWriteWB, RdWB, ResultWB} <= '0;
        else
            begin
                {RegWriteWB, RdWB, ResultWB} <= {RegWriteM, RdM, ResultM};
            end
endmodule
