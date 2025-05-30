module IF_ID_REG
    #(parameter XLEN = 32)
    (
        input   logic                   clk, clr, en, reset,
        input   logic [XLEN-1:0]        instrF,
        input   logic [XLEN-1:0]        PCF,
        input   logic [XLEN-1:0]        PCPlus4F,
        output  logic [XLEN-1:0]        instrD,
        output  logic [XLEN-1:0]        PCD,
        output  logic [XLEN-1:0]        PCPlus4D
    );
    always_ff @(posedge clk, posedge reset)
        if (clr | reset)
           begin
              instrD <= 0;
              PCD <= 0;
              PCPlus4D <= 0;  
           end 
        else if (~en)
            begin
              instrD <= instrF;
              PCD <= PCF;
              PCPlus4D <= PCPlus4F;  
            end
endmodule
