`include "uvm_macros.svh"
package monitor_pkg;
    import global_defs_pkg::*;
    import instr_pkg::*;
    import uvm_pkg::*;
    import gen_pkg::*;
    
    `define MON_IF vif.monitor_cb
    class cpu_monitor extends uvm_monitor;
        virtual cpu_if vif;
        mon_sb_trans trans;
        uvm_analysis_port #(mon_sb_trans) trans_collected_port;

        `uvm_component_utils(cpu_monitor);

        function new(string name, uvm_component parent);
            super.new(name, parent);
            trans = new();
            trans_collected_port = new("trans_collected_port", this);
        endfunction //new()

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            if (!uvm_config_db#(virtual cpu_if)::get(this, "", "cpu_if", vif))
                $display("Failed to get cpu virtual interface!");     
        endfunction

        virtual task automatic run_phase(uvm_phase phase);
            forever begin
                collect();
                trans_collected_port.write(trans);
            end
        endtask //automatic

        virtual task automatic collect();
        @`MON_IF;
        trans.reset = `MON_IF.reset;
        trans.WriteData = `MON_IF.WriteData;
        trans.DataAdr = `MON_IF.DataAdr;
        trans.MemWrite = `MON_IF.MemWrite;
        trans.MemWriteSelect = `MON_IF.MemWriteSelect;
        trans.ReadData = `MON_IF.ReadData;
        trans.PC = `MON_IF.PC;
        trans.instr = `MON_IF.instr;
        trans.ALUResultE = `MON_IF.ALUResultE;
        endtask

        
    endclass //cpu_monitor extends uvm_monitor
endpackage