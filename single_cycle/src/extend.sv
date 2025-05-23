module extend
    (
        input logic     [31:7]  instr,
        input logic     [1:0]   immsrc,
        output logic    [31:0]  immext
    );
    
    always_comb
        begin
            case(immsrc)
                //  I-type
                2'b00:  immnext = $sign(instr[31:20]);
                //  S-type
                2'b01:  immext = $sign({instr[31:25], instr[11:7]});
                //  B-type
                2'b10:  immext = $sign({instr[31], instr[7], instr[30:25], instr[11:8], 1'b0});
                //  J-type
                2'b11:  immext = $sign({instr[31], instr[19:12], instr[20], instr[30:21], 1'b0});
                default:    immext = 'bx;   //  undefined
            endcase
        end
endmodule
