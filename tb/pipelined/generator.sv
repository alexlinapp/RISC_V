
package gen;

    import instr_pkg::*;
    import global_defs_pkg::*;
    class generateOp;
        rand instr_pkg::op_t op;
        //  main constraints for generating types of insutrctions
        constraint op_c {
            op dist {
                    OP_LOAD := 1,
                    OP_IMM  := 5,
                    OP_R    := 5
                
                
                
                };
            }
        function new();
            
        endfunction //new()
    endclass //generateOP()

    class Instruction;
        rand instr_pkg::op_t op;
        rand bit signed [31:0] imm;
        rand bit [2:0] rd, rs1, rs2;
        rand bit [2:0] funct3, funct7;
        bit signed [31:0] PC;

        function new();
            PC = 0;
        endfunction //new()


        constraint op_c {
            op dist {
                    OP_LOAD := 1,
                    OP_IMM  := 5,
                    OP_R    := 5
                
                };
            }
        constraint reg_c {
            rd inside {[0:31]};
            rs1 inside {[0:31]};
            rs2 inside {[0:31]};
            if (op == OP_JALR || op == OP_JAL)
                rd == 0;


        }
        constraint imm_c {
            if (op == OP_JALR) {
                imm [11:0] inside {[-1 * PC : IMEM_SIZE * 4 - 1]};
                imm [1:0] == 0;
            }
            else if (op == OP_JAL) {
                imm [20:0] inside {[-1 * PC : IMEM_SIZE * 4- 1]};
                imm [1:0] == 0;
            }
            else if (op == OP_B) {
                imm [12:0] inside {[-1 * PC : IMEM_SIZE * 4 - 1]};
                imm [1:0] == 0;
            }
                

        }
        
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

        constraint funct7_c {
            if (op == OP_IMM && funct3 == 1)
                funct7 == 0;
            else if (op == OP_IMM && funct3 == 5 || op == OP_R && funct3 == 0 || op == OP_R && funct3 == 5)
                funct7 inside {[0:1]};
            else if (op == OP_R)
                funct7 == 0; 
        }
        

        function bit [31:0] getInstruction(input bit signed [31:0] PC);
            this.PC = PC;
            this.randomize();
            
            if (this.op == OP_IMM || this.op == OP_LOAD || this.op == OP_JALR)
                return {imm[11:0], rs1, funct3, rd, op};
            else if (this.op == OP_B)
                return {imm[12], imm[10:5], rs2, rs1, funct3, imm[4:1], imm[1], op};
            else if (this.op == OP_R)
                return {funct7, rs2, rs1, funct3, rd, op};
            else if (this.op == OP_STORE)
                return {imm[11:5], rs2, rs1, funct3, imm[4:0], op};
            else if (this.op == OP_JAL)
                return {imm[20], imm[10:1], imm[11], imm[19:12]};
            else if (this.op == OP_AUIPC || this.op == OP_LUI)
                return {imm[31:12], rd, op};
        endfunction
    endclass //className



endpackage