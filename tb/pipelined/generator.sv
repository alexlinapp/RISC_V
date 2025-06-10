
package gen;

    import instr_pkg::*;
    import global_defs_pkg::*;
    class generateOp;
        rand instr_pkg::op_t op;
        //  main constraints for generating types of insutrctions
        
        function new();
            
        endfunction //new()
    endclass //generateOP()

    class Instruction;
        rand instr_pkg::op_t op;
        rand logic signed [31:0] imm;
        rand bit [4:0] rd, rs1, rs2;
        rand bit [2:0] funct3, funct7;
        logic signed [31:0] PC;
        logic signed [31:0] min_12, max_12, min_11, max_11, min_20, max_20;
        function new();
            PC = 0;
        endfunction //new()


        
        // constraint reg_c {
        //     rd inside {[0:31]};
        //     rs1 inside {[0:31]};
        //     rs2 inside {[0:31]};
        //     if (op == OP_JALR || op == OP_JAL)
        //         rd == 0;
        // }
        
        
        constraint funct3_c {
            if (op == OP_IMM || op == OP_R)
                funct3 inside {[0:7]};
            else if (op == OP_B)
                funct3 inside {[0:1], [4:7]};
            else if (op == OP_LOAD)
                funct3 inside {[0:2], [4:5]};
            else if (op == OP_STORE)
                funct3 inside {[0:2]};
            else if (op == OP_JALR || op == OP_BUBBLE)
                funct3 == 3'b000;
        }

        
        function void buildRandomize(input bit signed [31:0] PC);
            this.PC = PC;
            min_12 = -4096 < -this.PC ? -this.PC : -4096;
            max_12 = 4095 > IMEM_SIZE * 4 - 1 ? IMEM_SIZE * 4 - 1 : 4095;
            min_11 = -2048 <- this.PC ? -this.PC : -2048;
            max_11 = 2047 > IMEM_SIZE * 4 - 1 ? IMEM_SIZE * 4 - 1 : 2047;
            min_20 = -(1 << 20) < -this.PC ? -this.PC : -(1 << 20);
            max_20 = ((1 << 20) - 1) > IMEM_SIZE * 4 - 1 ? IMEM_SIZE * 4 - 1 : ((1 << 20) - 1);
            // $display("min_12: %0d, max_12: %0d, min_11: %0d, max_11: %0d, min_20: %0d, max_20: %0d", min_12, max_12, min_11, max_11, min_20, max_20);
            // $display("INSIDE PC: %0d", this.PC * -1);
            // $display("IMEM: %0d", IMEM_SIZE * 4 -1);
            setOP();
            setImm();
            setFunct3();
            setFunct7();
        endfunction

        //  using constraints skewed data too much

        function void setOP();
            randcase
                1: op = OP_LUI;
                3: op = OP_B;
                2: op = OP_LOAD;
                5: op = OP_IMM;   
                5: op = OP_R;    
                3: op = OP_STORE; 
                2: op = OP_JAL;   
                1: op = OP_JALR;  
                1: op = OP_AUIPC; 
            endcase
            $display("THIS IS THE OP WE GET: %0d", op);
        endfunction



        function void setImm();
            if (op == OP_JALR) begin
                if (!std::randomize(imm) with {imm inside {[min_11:max_11]};})
                    $display("Failed to randomize %0s", op.name());
                imm [1:0] = 0;
            end
            else if (op == OP_JAL) begin
                if (!std::randomize(imm) with {imm inside {[min_20:max_20]};})
                    $display("Failed to randomize %0s", op.name());
                imm [1:0] = 0;
            end
            else if (op == OP_B) begin
                if (!std::randomize(imm) with {imm inside {[min_12:max_12]};})
                     $display("Failed to randomize %0s", op.name());
                imm [1:0] = 0;
            end
            else if (op == OP_IMM) begin
                if (funct3 == 3'b001)
                    imm[11:5] = 7'b0;
                else if (funct3 == 3'b101) begin
                    if (!std::randomize(imm) with {imm[11:5] inside {7'b0, 7'b0100000};})
                        $display("Failed to randomize %0s\t funct7", op.name());
                end
            end
            
        endfunction

        function setFunct3();
            if (op == OP_IMM || op == OP_R)
                if (!std::randomize(funct3) with {funct3 inside {[0:7]};})
                    $display("Failed to randomize %0s\t funct3", op.name());
            else if (op == OP_B)
                if (!std::randomize(funct3) with {funct3 inside {[0:1], [4:7]};})
                    $display("Failed to randomize %0s\t funct3", op.name());
            else if (op == OP_LOAD)
                if (!std::randomize(funct3) with {funct3 inside {[0:2], [4:5]};})
                    $display("Failed to randomize %0s\t funct3", op.name());
            else if (op == OP_STORE)
                if (!std::randomize(funct3) with {funct3 inside {[0:2]};})
                    $display("Failed to randomize %0s\t funct3", op.name());
            else if (op == OP_JALR || op == OP_BUBBLE)
                funct3 = 3'b000;
        endfunction
        function setFunct7();
            if (op == OP_IMM && funct3 == 1)
                funct7 = 0;
            else if (op == OP_R) begin  //  the immediate part has taken care of the funct7 for immediates
                if (funct3 == 3'b000 || funct3 == 3'b101)
                    if (!std::randomize(funct7) with {funct7 inside {7'b0, 7'b0100000};})
                        $display("Failed to randomize %0s", op.name());
                else
                    funct7 = 7'b0;
            end
            
        endfunction
        function logic [31:0] getInstruction(input bit signed [31:0] PC);
            
            if (this.op == OP_IMM || this.op == OP_LOAD || this.op == OP_JALR)
                return {imm[11:0], rs1, funct3, rd, op};
            else if (this.op == OP_B)
                return {imm[12], imm[10:5], rs2, rs1, funct3, imm[4:1], imm[1], op};
            else if (this.op == OP_R)
                return {funct7, rs2, rs1, funct3, rd, op};
            else if (this.op == OP_STORE)
                return {imm[11:5], rs2, rs1, funct3, imm[4:0], op};
            else if (this.op == OP_JAL)
                return {imm[20], imm[10:1], imm[11], imm[19:12], rd, op};
            else if (this.op == OP_AUIPC || this.op == OP_LUI)
                return {imm[31:12], rd, op};
            else if (this.op == OP_BUBBLE)
                return {32'b0};
        endfunction
    endclass //className



endpackage