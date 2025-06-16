`include "uvm_macros.svh"
package scoreboard_pkg;
    import uvm_pkg::*;
    import instr_pkg::*;
    import monitor_pkg::*;

    class cpu_scoreboard extends uvm_scoreboard;
        
        logic [31:0] q[$] = {0, 0, 0, 0, 0};

        uvm_analysis_imp#(instr_pkg::mon_sb_trans, cpu_scoreboard) trans_collected_export;

        int count = 64;
        `uvm_component_utils(cpu_scoreboard)
        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction //new()

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            trans_collected_export = new("item_collected_export", this);
        endfunction

        virtual function void write(mon_sb_trans item);
            $display("Output from CPU Recieved");
            $display("instr: %0h", item.instr);
            q.push_back(item.instr);
            $display("Instruction in Writeback: %0h", q.pop_front());
            $display("Size of queue: %0d", q.size());
            count--;
        endfunction

        // virtual function void compare(mons_sb_trans item);
            
            
        // endfunction

        virtual task run_phase(uvm_phase phase);
            //super.run_phase(phase);
            phase.raise_objection(this);
            wait (count == 0); // clean wait
            phase.drop_objection(this);
            $display("===Ending Test===");
        endtask
    endclass //cpu_sb extends uvm_score
endpackage