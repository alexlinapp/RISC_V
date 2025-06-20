`include "uvm_macros.svh"
package coverage_pkg;
    import uvm_pkg::*;
    import instr_pkg::*;
    import global_defs_pkg::*;
    class cpu_coverage extends uvm_component;
        
        mon_sb_trans trans;


        covergroup OP_coverage;
            OP: coverpoint op_t'(trans.instr[6:0]);
        endgroup


        // covergroup reg_coverage;
        //     rs1: coverpoint (getreg(trans))
        // endgroup

        uvm_analysis_imp #(mon_sb_trans, cpu_coverage) trans_coverage_export;

        `uvm_component_utils(cpu_coverage)
        
        function new(string name, uvm_component parent);
            super.new(name, parent);
            OP_coverage = new();
        endfunction //new()
        
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            trans_coverage_export = new("trans_coverage_export", this);
            
        endfunction

        function void write(mon_sb_trans item);
            trans = item;
            //  start to sample
            OP_coverage.sample();
            
        endfunction
    endclass //className
endpackage