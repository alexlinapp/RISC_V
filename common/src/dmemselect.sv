module dmemselect
    (
        input   logic [31:0]    ALUResultM,
        input   logic [31:0]    ReadData,
        input   logic [2:0]     funct3,
        output  logic [31:0]    ReadDataSelected
    );
    always_comb
        begin
            case(funct3)
                3'b000: case(ALUResultM[1:0])
                            2'b00: ReadDataSelected = $signed(ReadData[7:0]);
                            2'b01: ReadDataSelected = $signed(ReadData[15:8]);
                            2'b10: ReadDataSelected = $signed(ReadData[23:16]);
                            2'b11: ReadDataSelected = $signed(ReadData[21:24]);
                        endcase
                3'b001: case(ALUResultM[1:0])
                            2'b00: ReadDataSelected = $signed(ReadData[15:0]);
                            2'b10: ReadDataSelected = $signed(ReadData[31:16]);
                            default: ReadDataSelected = 'x;
                        endcase
                3'b010: ReadDataSelected = ReadData;
                3'b100: case(ALUResultM[1:0])
                            2'b00: ReadDataSelected = {24'b0, ReadData[7:0]};
                            2'b01: ReadDataSelected = {24'b0, ReadData[15:8]};
                            2'b10: ReadDataSelected = {24'b0, ReadData[23:16]};
                            2'b11: ReadDataSelected = {24'b0, ReadData[31:24]};
                        endcase
                3'b101: case(ALUResultM[1:0])
                            2'b00: ReadDataSelected = {16'b0, ReadData[15:0]};
                            2'b10: ReadDataSelected = {16'b0, ReadData[31:16]};
                            default: ReadDataSelected = 'x;
                        endcase
                default: ReadDataSelected = 'x;
            endcase
        end
endmodule
