module branchdec
    (
        input   logic Zero, LessThan, LessThanUnsigned, 
        input   logic funct3,
        output  logic BranchC
    );
    
    always_comb
        begin
            BranchC = 0;
            case(funct3)
                3'b000:     if (Zero)
                                BranchC = 1'b1; //  =
                3'b001:     if (~Zero)
                                BranchC = 1'b1; //  !=
                3'b100:     if (LessThan)
                                BranchC = 1'b1; //  < (unsigned)
                3'b101:     if (~LessThan)
                                BranchC = 1'b1; //  <= (unsigned)
                3'b110:     if (LessThanUnsigned)
                                BranchC = 1'b1;
                3'b111:     if (~LessThanUnsigned)
                                BranchC = 1'b1;
                default:    BranchC = 'x;
            endcase
        
        
        end
endmodule
