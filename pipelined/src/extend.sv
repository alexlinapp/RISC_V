module extend
    (
        input logic     [31:7]  instr,
        input logic     [2:0]   immsrc,
        output logic    [31:0]  immext
    );
    
    always_comb
        begin
            case(immsrc)
                //  I-type
                3'b000:  immext = $signed(instr[31:20]);
                //  S-type
                3'b001:  immext = $signed({instr[31:25], instr[11:7]});
                //  B-type
                3'b010:  immext = $signed({instr[31], instr[7], instr[30:25], instr[11:8], 1'b0});
                //  J-type
                3'b011:  immext = $signed({instr[31], instr[19:12], instr[20], instr[30:21], 1'b0});
                //  U-type
                3'b100:  immext = {instr[31:12], 12'b0};
                default:    immext = 'bx;   //  undefined
            endcase
        end
endmodule
