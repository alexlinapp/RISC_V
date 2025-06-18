package reference_model_pkg;
    import global_defs_pkg::*;
    import instr_pkg::*;
    class reference_model;
        logic [XLEN-1:0] rf [31:0];     // register file
        logic [XLEN-1:0] DMEM [DMEM_SIZE-1:0];
        logic [XLEN-1:0] IMEM [IMEM_SIZE-1:0];
        logic [31:0] PC;
        logic [2:0] funct3;
        logic [6:0] funct7;
        logic [4:0] rd, rs1, rs2;
        logic [31:0] instr;
        op_t op;
        function new();
            foreach (rf[i])
                rf[i] = '0;
            foreach (DMEM[i])
                DMEM[i] = '0;
            PC = '0;
        endfunction //new()

        function void expected_output(logic [31:0] instr, input logic [31:0] PC = 0);
            int address;
            logic [XLEN-1:0] ReadData;
            {funct7, rs2, rs1, funct3, rd, op} = instr;
            this.instr = instr;
            this.PC = PC;
            
            if (instr[6:0] == OP_LOAD) begin
                address = getAddress(instr, rf);
                ReadData = DMEM[(address) >> 2];
                $display("We are reading this data: %0h from this address: %0d", ReadData, address);
                case (instr[14:12])
                    3'b000: begin case(address[1:0])
                            2'b00: rf[instr[11:7]] = $signed(ReadData[7:0]);
                            2'b01: rf[instr[11:7]] = $signed(ReadData[15:8]);
                            2'b10: rf[instr[11:7]] = $signed(ReadData[23:16]);
                            2'b11: rf[instr[11:7]] = $signed(ReadData[31:24]);
                       endcase
                    end
                    3'b001: begin case(address[1:0])
                                2'b00: rf[instr[11:7]] = $signed(ReadData[15:0]);
                                2'b10: rf[instr[11:7]] = $signed(ReadData[31:16]);
                                default: rf[instr[11:7]] = 'x;
                        endcase
                    end
                    3'b010: rf[instr[11:7]] = ReadData;
                    3'b100: begin case(address[1:0])
                                2'b00: rf[instr[11:7]] = {24'b0, ReadData[7:0]};
                                2'b01: rf[instr[11:7]] = {24'b0, ReadData[15:8]};
                                2'b10: rf[instr[11:7]] = {24'b0, ReadData[23:16]};
                                2'b11: rf[instr[11:7]] = {24'b0, ReadData[31:24]};
                        endcase
                    end
                    3'b101: begin case(address[1:0])
                                2'b00: rf[instr[11:7]] = {24'b0, ReadData[15:0]};
                                2'b10: rf[instr[11:7]] = {24'b0, ReadData[31:16]};
                                default: rf[instr[11:7]] = 'x;
                        endcase 
                    end
                        default: $display("Invalid Load Instruction");
                endcase
            end
                
            else if (instr[6:0] == OP_IMM || op == OP_R) begin
                expected_ALU_OP();
            end
            else if (instr[6:0] == OP_STORE) begin
                expected_OP_STORE();
            end
            else if (instr[6:0] == OP_B) begin
                expected_OP_B();
            end
            else if (instr[6:0] == OP_JAL) begin
                expected_OP_JAL();
            end
            else if (instr[6:0] == OP_JALR) begin
                expected_OP_JAL();
            end
            else if (instr[6:0] == OP_AUIPC) begin
                expected_OP_AUIPC();
            end
            else if (instr[6:0] == OP_LUI) begin
                expected_OP_LUI();
            end
            
        endfunction

        function void expected_OP_STORE();
            logic [31:0] a = rf[rs1] + $signed({funct7, rd});
            case (funct3)
                3'b000: DMEM[a[31:2]][8*a[1:0] +:8] = rf[rs2][7:0];
                3'b001: DMEM[a[31:2]][8*a[1:0] +:16] = rf[rs2][15:0];
                3'b010: DMEM[a[31:2]] = rf[rs2];
                default: $display("Failed to Store!");
            endcase
            
            
        endfunction

        function void expected_ALU_OP();
            logic [31:0] secondInput; 
            if (rd == 0) begin
                return;
            end
            if (op == OP_IMM)
                secondInput = {{21{funct7[6]}}, funct7[5:0], rs2};
            else if (op == OP_R)
                secondInput = rf[rs2];
            case (funct3)
                3'b000: case(op)
                            OP_R: case(funct7)
                                    7'b0000000: rf[rd] = rf[rs1] + secondInput;
                                    7'b0100000: rf[rd] = rf[rs1] - secondInput;
                                    endcase
                            OP_IMM: rf[rd] = rf[rs1] + secondInput;
                            endcase
                3'b001: rf[rd] = rf[rs1] << secondInput[4:0];
                3'b010: rf[rd] = signed'(rf[rs1]) < signed'(secondInput);
                3'b011: rf[rd] = rf[rs1] < secondInput;
                3'b100: rf[rd] = rf[rs1] ^ secondInput;
                3'b101: case(funct7)
                            7'b0000000: rf[rd] = rf[rs1] >> secondInput[4:0];
                            7'b0100000: rf[rd] = signed'(rf[rs1]) >>> secondInput[4:0];
                        endcase
                3'b110: rf[rd] = rf[rs1] | secondInput;
                3'b111: rf[rd] = rf[rs1] & secondInput;
                default: $display("Invalid Instruction: OP: %0s", op.name());
            endcase

            
        endfunction




        function void expected_OP_B();
            
            
            
        endfunction

        function void expected_OP_JAL();
            rf[rd] = PC + 4;
        endfunction

        function void expected_OP_AUIPC();
            rf[rd] = getimm(instr) + PC;
            
        endfunction

        function void expected_OP_LUI;
            rf[rd] = getimm(instr);
        endfunction
    endclass //reference_model
    
endpackage