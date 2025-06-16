`include "uvm_macros.svh"
package scoreboard_pkg;
    import uvm_pkg::*;
    import global_defs_pkg::*;
    import instr_pkg::*;
    import monitor_pkg::*;

    class cpu_scoreboard extends uvm_scoreboard;
        
        logic [31:0] q[$] = {0, 0, 0, 0};
        //  writeback, memory, execute, decode
        logic [31:0] rf [32];



        uvm_analysis_imp#(instr_pkg::mon_sb_trans, cpu_scoreboard) trans_collected_export;

        int count = 64;
        `uvm_component_utils(cpu_scoreboard)
        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction //new()

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            trans_collected_export = new("item_collected_export", this);
            rf[0] = 32'b0;
        endfunction

        virtual function void write(mon_sb_trans item);
            $display("Output from CPU Recieved");
            $display("instr: %0h", item.instr);
            if (!$isunknown(item.instr)) begin
                q.push_back(item.instr);
                //$display("Pushed back %0h". item.instr);
            end
            $display("Instruction in Writeback: %0h", q.pop_front());
            $display("Size of queue: %0d", q.size());
            count--;
        endfunction

        // virtual function void compare(mons_sb_trans item);
        virtual function void compare(input mon_sb_trans item);
            case (getop(item.instr))
                OP_LOAD  : assert (check_OP_LOAD()) 
                else   $fatal(1, "Failed: %0s", getop(item.instr).name());   
                OP_IMM   : assert (check_OP_IMM()) 
                else   $fatal(1, "Failed: %0s", getop(item.instr).name());   
                OP_STORE : assert (check_OP_STORE()) 
                else   $fatal(1, "Failed: %0s", getop(item.instr).name());    
                OP_R     : assert (check_OP_R()) 
                else   $fatal(1, "Failed: %0s", getop(item.instr).name());       
                OP_B     : assert (check_OP_B()) 
                else   $fatal(1, "Failed: %0s", getop(item.instr).name());    
                OP_JAL   : assert (check_OP_JAL()) 
                else   $fatal(1, "Failed: %0s", getop(item.instr).name());    
                OP_JALR  : assert (check_OP_JALR()) 
                else   $fatal(1, "Failed: %0s", getop(item.instr).name());    
                OP_AUIPC : assert (check_OP_AUIPC()) 
                else   $fatal(1, "Failed: %0s", getop(item.instr).name());    
                OP_LUI   : assert (check_OP_LUI()) 
                else   $fatal(1, "Failed: %0s", getop(item.instr).name());    
                OP_BUBBLE: assert (check_OP_LOAD()) 
                else   $fatal(1, "Failed: %0s", getop(item.instr).name());                
            endcase
            
        endfunction

        virtual function int check_OP_LOAD();
            
            return 1;
        endfunction

        virtual function int check_OP_IMM();
            return 1;
            
        endfunction
        virtual function int check_OP_STORE();
            return 1;
            
        endfunction
        virtual function int check_OP_R();
            return 1;
            
        endfunction
        virtual function int check_OP_B();
            return 1;
            
        endfunction
        virtual function int check_OP_JAL();
            return 1;
            
        endfunction
        virtual function int check_OP_JALR();
            return 1;
            
        endfunction
        virtual function int check_OP_AUIPC();
            return 1;
            
        endfunction
        virtual function int check_OP_LUI();
            return 1;
            
        endfunction
            
        // endfunction

        virtual task run_phase(uvm_phase phase);
            //super.run_phase(phase);
            phase.raise_objection(this);
            wait (q.size() == 0 || count <= 0); // clean wait, need to prevent infinite loops as well
            phase.drop_objection(this);
            $display("===Ending Test===");
        endtask
    endclass //cpu_sb extends uvm_score
endpackage