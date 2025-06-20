module mux8
    #(parameter XLEN = 32)
    (
        input   logic [XLEN-1:0]    d [7:0], 
        input   logic [2:0]         s,
        output  logic [XLEN-1:0]    y
    );
    assign y = d[s];
endmodule
