module dmemselect
    (
        input   logic [31:0]    ReadData,
        input   logic [2:0]     funct3,
        output  logic [31:0]    ReadDataSelected
    );
    always_comb
        begin
            case(funct3)
                3'b000: ReadDataSelected = $signed(ReadData[7:0]);
                3'b001: ReadDataSelected = $signed(ReadData[15:0]);
                3'b010: ReadDataSelected = ReadData;
                3'b100: ReadDataSelected = {24'b0, ReadData[7:0]};
                3'b101: ReadDataSelected = {15'b0, ReadData[15:0]};
                default: ReadDataSelected = 'x;
            endcase
        end
endmodule
