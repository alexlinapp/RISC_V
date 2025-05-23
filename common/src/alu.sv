module alu
    #(parameter XLEN = 32)
    (
        input logic [XLEN-1:0]  a, b,
        input logic [2:0]       alucontrol,
        output logic [XLEN-1:0] y
    );
    always_comb 
    begin
        case(alucontrol)
            3'b000: y = a + b;
            3'b001: y = a - b;
            3'b010: y = a & b;
            3'b011: y = a | b;
            3'b000: y = (a < b) ? 'b1 : 'b0;    //  SLT (Set if Less than)
            default: y = 'x;
        endcase
    end
endmodule
