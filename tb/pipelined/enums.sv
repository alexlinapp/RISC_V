`include "uvm_macros.svh"
package instr_pkg;
    
  import global_defs_pkg::*;
  import uvm_pkg::*;
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

  function op_t getop(logic [31:0] instr);
      return op_t'(instr[6:0]);
  endfunction

      /*
      returns: {rs2, rs1, rd}
      */
  function int getreg(logic [31:0] instr, int r);
      case(r)
        0:  return instr[11:7];
        1:  return instr[19:15];
        2:  return instr[24:20];
        default: $display("Provided Invalid reg");
      endcase
  endfunction
      /*

      */
  function logic [2:0] getfunct3(logic [31:0] instr);
      return instr[14:12];
  endfunction


  function logic [6:0] getfunct7(logic [31:0] instr);
      return instr[31:25];        
  endfunction

  function int getimm(logic [31:0] instr);
          case (getop(instr))
              OP_LOAD   : return signed'(instr[31:20]);
              OP_IMM    : return signed'(instr[31:20]);
              OP_STORE  : return signed'(instr[31:20]);
              OP_R      : return 0;
              OP_B      : return signed'({instr[31], instr[7], instr[30:25], instr[11:8], 1'b0});   
              OP_JAL    : return signed'({{12{instr[31]}}, instr[19:12], instr[20], instr[30:25], instr[24:21], 1'b0});
              OP_JALR   : return signed'(instr[31:20]);
              OP_AUIPC  : return {instr[31:12], 12'b0};
              OP_LUI    : return {instr[31:12], 12'b0};
              OP_BUBBLE : return 0;
              default   : $display("Incorrect op for getImm!");
          endcase
          
  endfunction

  function automatic int getAddress(logic [31:0] instr, ref logic [31:0] rf [31:0]);
    //$display("inside of getAddress: getimm: %0d, rf: %0d, rfvalue: %0d", getimm(instr), getreg(instr, 1), signed'(rf[getreg(instr, 1)]));
    //$display("====GetAddress Reg===");
    case (getop(instr))
      OP_STORE: return getimm(instr) + signed'(rf[getreg(instr, 1)]);
      OP_LOAD:  return getimm(instr) + signed'(rf[getreg(instr, 1)]);
      default: $display("Cannot get address of %0s", getop(instr).name());
    endcase
    //  should not reach here
    return 0;
    
  endfunction


  class mon_sb_trans extends uvm_transaction;
        logic reset;
        logic [31:0]    WriteData, DataAdr;
        logic           MemWrite;
        logic [3:0]     MemWriteSelect;
        logic [31:0]    ReadData;
        logic [31:0]    PC;
        logic [31:0]    instr;
        //  DUT internal signals

        
        //  part of datapath
        logic [31:0]  rf [31:0];

        //  Memories
        logic [31:0] DMEM [DMEM_SIZE-1:0];

        //  inside riscvsingle
        logic [31:0]    ALUResultE;



        `uvm_object_utils_begin(mon_sb_trans)
          `uvm_field_int(instr, UVM_DEFAULT)
          `uvm_field_int(PC, UVM_DEFAULT)


        `uvm_object_utils_end
        function new(string name = "mon_sb_trans");
            super.new(name);
        endfunction //new()
    endclass //instruction_trans extends uvm_transaction


    
endpackage