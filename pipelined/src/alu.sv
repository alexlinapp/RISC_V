module alu
    #(parameter XLEN = 32)
    (
        input   logic [XLEN-1:0]    a, b,
        input   logic [3:0]         ALUControl,
        output  logic [XLEN-1:0]    ALUResult,
        output  logic               Zero,
        output  logic               LessThan,
        output  logic               LessThanUnsigned
    );
    always_comb 
    begin
        case(ALUControl)
            4'b0000: ALUResult = a + b;
            4'b0001: ALUResult = a - b;
            4'b0010: ALUResult = a & b;
            4'b0011: ALUResult = a | b;
            4'b0100: ALUResult = a ^ b;
            4'b0101: ALUResult = ($signed(a) < $signed(b)) ? 'b1 : 'b0;    //  SLT (Set if Less than [signed])
            4'b0110: ALUResult = a >> b[4:0];
            4'b0111: ALUResult = $signed(a) >>> b[4:0];
            4'b1000: ALUResult = a << b[4:0];
            4'b1001: ALUResult = (a < b) ? 'b1 : 'b0;                       // SLTU (Set if less than, unsigned comparison)
            default: ALUResult = 'x;
        endcase
    end
    
    assign Zero = ALUResult ? 1'b0 : 1'b1;
    assign LessThan = ALUResult[0] ? 'b1 : 'b0;
    assign LessThanUnsigned = ALUResult[0] ? 'b1 : 'b0;
endmodule
