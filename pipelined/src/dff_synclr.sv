module dff_synclr
    #(parameter XLEN = 32)
    (
        input   logic               clk, clr,
        input   logic [XLEN-1:0]    d,
        output  logic [XLEN-1:0]    q 
    );
    always_ff @(posedge clk)
        if (clr)
            q <= 0;
        else
            q <= d;
endmodule
