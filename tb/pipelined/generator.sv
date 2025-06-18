`include "uvm_macros.svh"
package gen_pkg;
    //import uvm_pkg::*;
    import instr_pkg::*;
    import global_defs_pkg::*;
    import reference_model_pkg::*;
    class Instruction;
        rand instr_pkg::op_t op;
        rand logic signed [31:0] imm;
        rand bit [4:0] rd, rs1, rs2;
        rand bit [2:0] funct3, funct7;
        logic signed [31:0] PC;
        logic signed [31:0] min_12, max_12, min_11, max_11, min_20, max_20;
        reference_model ref_model;
        function new();
            PC = 0;
            ref_model = new();
        endfunction //new()


        
        // constraint reg_c {
        //     rd inside {[0:31]};
        //     rs1 inside {[0:31]};
        //     rs2 inside {[0:31]};
        //     if (op == OP_JALR || op == OP_JAL)
        //         rd == 0;
        // }
        
        
        // constraint funct3_c {
        //     if (op == OP_IMM || op == OP_R)
        //         funct3 inside {[0:7]};
        //     else if (op == OP_B)
        //         funct3 inside {[0:1], [4:7]};
        //     else if (op == OP_LOAD)
        //         funct3 inside {[0:2], [4:5]};
        //     else if (op == OP_STORE)
        //         funct3 inside {[0:2]};
        //     else if (op == OP_JALR || op == OP_BUBBLE)
        //         funct3 == 3'b000;
        // }

        
        function void buildRandomize();
            min_12 = -4096 < -this.PC ? -this.PC : -4096;
            max_12 = 4095 > IMEM_SIZE * 4 - 1 ? IMEM_SIZE * 4 - 1 : 4095;
            min_11 = -2048;//-2048 <- this.PC ? -this.PC : -2048;
            max_11 = 2047;//2047 > IMEM_SIZE * 4 - 1 ? IMEM_SIZE * 4 - 1 : 2047;
            min_20 = -(1 << 20) < -this.PC ? -this.PC : -(1 << 20);
            max_20 = ((1 << 20) - 1) > IMEM_SIZE * 4 - 1 ? IMEM_SIZE * 4 - 1 : ((1 << 20) - 1);
            $display("min_12: %0d, max_12: %0d, min_11: %0d, max_11: %0d, min_20: %0d, max_20: %0d", min_12, max_12, min_11, max_11, min_20, max_20);
            //$display("INSIDE PC: %0d", this.PC * -1);
            //$display("IMEM: %0d", IMEM_SIZE * 4 -1);
            //  in order, first setOP, then setImm, then setFunct3, then setFunct7
        endfunction

        function void customRandomize();
            setreg();
            setOP();
            setFunct3();
            setFunct7();
            setImm();
            this.PC += 4;
        endfunction
        //  using constraints skewed data too much, use manual setOP

        function void setOP();
            randcase
                0: op = OP_LUI;
                0: op = OP_B;
                1: op = OP_LOAD;
                1: op = OP_IMM;   
                2: op = OP_R;    
                0: op = OP_STORE; 
                0: op = OP_JAL;   
                0: op = OP_JALR;  
                0: op = OP_AUIPC; 
            endcase
            $display("THIS IS THE OP WE GET: %0d", op);
        endfunction

        function void setreg();
            if (!std::randomize(rs1) with {rs1 inside {[0:31]};})
                $display("Failed to randomize rs1");
            if (!std::randomize(rs2) with {rs2 inside {[0:31]};})
                $display("Failed to randomize rs2");
            if (!std::randomize(rd) with {rd inside {[0:31]};})
                $display("Failed to randomize rsd"); 
        endfunction

        function void setImm();
            if (op == OP_JALR) begin
                if (!std::randomize(imm) with {imm inside {[min_11:max_11]};})
                    $display("Failed to randomize %0s", op.name());
                imm [1:0] = 0;
                while (imm < -this.PC || imm > IMEM_SIZE * 4 - 1) begin
                    if (!std::randomize(imm) with {imm inside {[min_11:max_11]};})
                    $display("Failed to randomize %0s", op.name());
                    imm [1:0] = 0;
                end
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
                $display("THis is imm: %0d", signed'(imm[12:0]));
            end
            else if (op == OP_IMM) begin
                if (funct3 == 3'b001)
                    imm[11:5] = 7'b0;
                else if (funct3 == 3'b101) begin
                    if (!std::randomize(imm) with {imm[11:5] inside {7'b0, 7'b0100000};})
                        $display("Failed to randomize %0s funct7", op.name());
                end
                else begin
                    if (!std::randomize(imm) with {imm inside {[min_11:max_11]};})
                        $display("Failed to randomize %0s", op.name()); 
                end
            //$display("This is imm: %0b", imm);
            end
            else if (op == OP_STORE || op == OP_LOAD) begin
                int d = 1;
                int rs1temp;
                case (funct3)
                    3'b000, 3'b100: begin
                        d = 1;
                    end
                    3'b001, 3'b101: begin
                        d = 2;
                    end
                    3'b010: begin
                        d = 4;
                    end
                    default: $display("invalid funct3 in generator");
                    endcase
                if (!std::randomize(imm) with {imm inside {[min_11:max_11]}; }) begin
                    $fatal(1, "Failed to randomize imm");
                end
                while (signed'(ref_model.rf[rs1]) < -2047 || ref_model.rf[rs1] > 1024 + DMEM_SIZE * 4) begin
                    std::randomize(rs1) with {rs1 inside {[0:31]}; };
                    $display("This is rs1: %0d", rs1);
                end
                
                    rs1temp = signed'(ref_model.rf[rs1]);
                    std::randomize(imm) with {imm inside {[min_11:max_11]}; 
                                                (rs1temp + imm) >= 0;
                                                (rs1temp + imm) % d == 0;
                                                (rs1temp + imm) <= (DMEM_SIZE * 4 - 1);
                                                };
                    $display("This is imm: %0d", imm);
            end
            else begin
                if(!std::randomize(imm))
                    $fatal(1, "failed to randoomize imm");
            end
            
        endfunction

        function void setFunct3();
            //$display("op: %0d", op == OP_JALR);
            if (op == OP_IMM || op == OP_R) begin
                if (!std::randomize(funct3) with {funct3 inside {[0:7]};})
                    $display("Failed to randomize %0s\t funct3", op.name());
            end
            else if (op == OP_B) begin
                if (!std::randomize(funct3) with {funct3 inside {[0:1], [4:7]};})
                    $display("Failed to randomize %0s\t funct3", op.name());
                
                //$display("THis is funct3: %0b:", funct3);
            end
            else if (op == OP_LOAD) begin
                if (!std::randomize(funct3) with {funct3 inside {[0:2], [4:5]};}) begin
                    $display("Failed to randomize %0s\t funct3", op.name());
                end
            end
            else if (op == OP_STORE) begin
                if (!std::randomize(funct3) with {funct3 inside {[0:2]};}) begin
                    $display("Failed to randomize %0s\t funct3", op.name());
                end
            end
            else if (op == OP_JALR) begin
                funct3 = 3'b000;
                //$display("This is : %0s, funct3: %0b", op.name(), funct3);
            end
        endfunction

        function void setFunct7();
            if (op == OP_IMM && funct3 == 1)
                funct7 = 0;
            else if (op == OP_R) begin  //  the immediate part has taken care of the funct7 for immediates
                if (funct3 == 3'b000 || funct3 == 3'b101) begin
                    if (!std::randomize(funct7) with {funct7 inside {7'b0, 7'b0100000};}) begin
                        $display("Failed to randomize %0s", op.name());
                    end
                end
                else begin
                    funct7 = 7'b0;
                end
            end
            
        endfunction

        function logic [31:0] getInstruction();
            logic [31:0] instr;
            if (this.op == OP_IMM || this.op == OP_LOAD || this.op == OP_JALR)
                instr = {imm[11:0], rs1, funct3, rd, op};
            else if (this.op == OP_B)
                instr = {imm[12], imm[10:5], rs2, rs1, funct3, imm[4:1], imm[11], op};
            else if (this.op == OP_R)
                instr = {funct7, rs2, rs1, funct3, rd, op};
            else if (this.op == OP_STORE)
                instr = {imm[11:5], rs2, rs1, funct3, imm[4:0], op};
            else if (this.op == OP_JAL)
                instr = {imm[20], imm[10:1], imm[11], imm[19:12], rd, op};
            else if (this.op == OP_AUIPC || this.op == OP_LUI)
                instr = {imm[31:12], rd, op};
            else if (this.op == OP_BUBBLE)
                instr = {32'b0};
            ref_model.expected_output(instr, PC - 4);
            return instr;
        endfunction
    endclass //className

    

endpackage