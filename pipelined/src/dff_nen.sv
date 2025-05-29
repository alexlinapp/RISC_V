module dff_nen
    #(parameter XLEN = 32)
    (
        input   logic               clk, reset, en,
        input   logic [XLEN-1:0]    d,
        output  logic [XLEN-1:0]    q
    );
    
    always_ff @(posedge clk, posedge reset)
        if (reset)
            q <= 0;
        else if (~en)
            q <= d;
endmodule
