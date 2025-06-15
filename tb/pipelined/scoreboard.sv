`include "uvm_macros.svh"
package scoreboard_pkg
    import uvm_pkg::*;
    import instr_pkg::*;
    import monitor_pkg::*;

    class cpu_scoreboard extends uvm_scoreboard;
        
        uvm_analysis_imp#(mon_sb_trans, cpu_scoreboard) trans_collected_export;


        `uvm_component_utils(cpu_scoreboard);
        function new(string name, uvm_component parent);
            super.new(name, parnet);
        endfunction //new()

        function void build_phase(uvm_phase phase)
            super.build_phase(phase);
            trans_collected_export = new("item_collected_export", this);
        endfunction

        virtual function void write(mons_sb_trans item);
            $display("Output from CPU Recieved");
            
        endfunction

        virtual function void compare(mons_sb_trans item);
            
            
        endfunction
    endclass //cpu_sb extends uvm_score
endpackage