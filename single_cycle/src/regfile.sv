module regfile
    #(parameter XLEN = 32)
    (
        input logic                 clk,
        input logic                 we3,
        input logic     [5:0]       a1, a2, a3,
        input logic     [XLEN-1:0]  wd3, 
        output logic    [XLEN-1:0]  rd1, rd2
    );
    
    //  three ported register file
    logic [XLEN-1:0] rf[XLEN-1:0];
    
    always_ff @(posedge clk)
        if (we3)
            rf[a3] <= wd3;
    assign rd1 = (a1 != 0) ? rf[a1] : 0;   //  of a1 = 0, zero register by definition holds 0
    assign rd2 = (a2 != 0) ? rf[a2] : 0;
endmodule
`end_keywords