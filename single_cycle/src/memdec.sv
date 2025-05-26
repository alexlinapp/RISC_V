module memdec
    (
        input   logic       MemWrite,
        input   logic [2:0] funct3,
        output  logic [3:0] MemWriteSelect
    );
    always_comb 
        begin
            MemWriteSelect = 4'b0000;
            if (MemWrite)
                case(funct3)
                    3'b000:     MemWriteSelect = 4'b0001;
                    3'b001:     MemWriteSelect = 4'b0010;
                    3'b010:     MemWriteSelect = 4'b1000;
                    default:    MemWriteSelect = 'x;
                endcase
        end
endmodule
