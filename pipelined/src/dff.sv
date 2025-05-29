module dff
    #(parameter XLEN = 8)
    (
        input logic                 clk, reset,
        input logic [XLEN - 1:0]    d,
        output logic [XLEN - 1:0]   q
    );
    always_ff @(posedge clk, posedge reset)
        if (reset)
            q <= 0;
        else
            q <= d;
endmodule
