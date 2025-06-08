package instr_pkg;
    
    import global_defs_pkg::*;

    typedef enum logic [6:0] {
        OP_LOAD     = 7'b0000011,
        OP_IMM      = 7'b0010011,
        OP_STORE    = 7'b0100011,
        OP_R        = 7'b0110011,   
        OP_B        = 7'b1100011,
        OP_JAL      = 7'b1101111,
        OP_JALR     = 7'b1100111,
        OP_AUIPC    = 7'b0010111,
        OP_LUI      = 7'b0110111,
        OP_BUBBLE   = 7'b0000000
      } op_t;

    

endpackage