module adder
    #(parameter XLEN = 32)
    (
        input logic [XLEN - 1: 0]   a, b,
        output logic [XLEN-1:0]     y
    );
    assign y = a + b;
endmodule
