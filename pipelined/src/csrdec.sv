module csrdec(
        input   logic [31:0]    instr,
        output logic            CSRWrite    
    );
    always_comb begin
        if (instr[6:0] == 7'b1110011) begin
            case(instr[14:12]) 
                3'b000: CSRWrite = 0;
                default: CSRWrite = 1;
            endcase
        
        end
        else begin
            CSRWrite = 0;
        end
        
    end
endmodule
