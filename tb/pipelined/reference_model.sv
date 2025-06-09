package reference_model_pkg;
    import global_defs_pkg::*;
    import instr_pkg::*;

    class reference_model;
        logic [XLEN-1:0] rf [31:0];     // register file
        logic [XLEN-1:0] IMEM [IMEM_SIZE], DMEM [DMEM_SIZE];
        logic [31:0] PC;
        function new();
            foreach (rf[i])
                rf[i] = '0;
            foreach (IMEM[i])
                IMEM[i] = '0;
            foreach (DMEM[i])
                DMEM[i] = '0;
            PC = '0;
        endfunction //new()

        function expected_output(ref logic [31:0] instr);
            if (instr[6:0] == OP_LOAD) {
                bit signed [31:0] address = rf[instr[19:15]] + instr[31:20];
                case (instr[14:12])
                    3'b000: rf[i] = {DMEM[address[31:2]]}
                    3'b001:
                    3'b010:
                    3'b100:
                    3'b101: 
                    default: 
                endcase
            }
            else if (instr[6:0] == OP_IMM) {

            }
            else if (instr[6:0] == OP_STORE) {

            }
            else if (instr[6:0] == OP_R) {

            }
            else if (instr[6:0] == OP_B) {

            }
            else if (instr[6:0] == OP_JAL) {

            }
            else if (instr[6:0] == OP_JALR) {

            }
            else if (instr[6:0] == OP_AUIPC) {

            }
            else if (instr[6:0] == OP_LUI) {

            }
            
        endfunction
    endclass //reference_model
    
endpackage