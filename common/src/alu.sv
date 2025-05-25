module alu
    #(parameter XLEN = 32)
    (
        input   logic [XLEN-1:0]    a, b,
        input   logic [2:0]         ALUControl,
        output  logic [XLEN-1:0]    ALUResult,
        output  logic               Zero
    );
    always_comb 
    begin
        case(ALUControl)
            3'b000: ALUResult = a + b;
            3'b001: ALUResult = a - b;
            3'b010: ALUResult = a & b;
            3'b011: ALUResult = a | b;
            3'b101: ALUResult = (a < b) ? 'b1 : 'b0;    //  SLT (Set if Less than)
            default: ALUResult = 'x;
        endcase
    end
    
    assign Zero = ALUResult ? 1'b0 : 1'b1;
endmodule
