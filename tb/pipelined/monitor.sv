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

        `uvm_component_utils(cpu_monitor)

        function new(string name, uvm_component parent);
            super.new(name, parent);
            trans_collected_port = new("trans_collected_port", this);
        endfunction //new()

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            if (!uvm_config_db#(virtual cpu_if)::get(this, "", "cpu_if", vif))
                $display("Failed to get cpu virtual interface!"); 
            trans = new();    
        endfunction

        virtual task automatic run_phase(uvm_phase phase);
            forever begin
                collect();
                trans_collected_port.write(trans);
                //displayReg();
            end
        endtask //automatic

        virtual task automatic collect();
        @`MON_IF;
        // trans.reset = `MON_IF.reset;
        // trans.WriteData = `MON_IF.WriteData;
        // trans.DataAdr = `MON_IF.DataAdr;
        // trans.MemWrite = `MON_IF.MemWrite;
        // trans.MemWriteSelect = `MON_IF.MemWriteSelect;
        // trans.ReadData = `MON_IF.ReadData;
        trans.PC = `MON_IF.PC;
        trans.instr = `MON_IF.instr;
        //trans.ALUResultE = `MON_IF.ALUResultE;
        foreach(trans.rf[i]) begin
            trans.rf[i] = `MON_IF.rf[i];
        end       
        // $display("===Trans rf Reg Values====");
        // foreach(trans.rf[i]) begin
            
        //     $write("Reg %0d: %0h \t", i, trans.rf[i]);
        // end
        // $display("===DUT Reg Values====");
        // foreach(trans.rf[i]) begin
            
        //     $write("Reg %0d: %0h \t", i, `MON_IF.rf[i]);
        // end
        //$display("===Memory====");
        foreach(trans.DMEM[i]) begin
            trans.DMEM[i]  = `MON_IF.DMEM[i];
            //$write("i: %0d, trans: %0h, DUT: %0h \t", i, trans.DMEM[i], `MON_IF.DMEM[i]);
        end
        //$display();
        endtask
       

        virtual function void displayReg();
            $display("===Reg Values===");
            for (int i = 0; i < 32; i++) begin
                $write("Reg %0d: %0h \t", i, trans.rf[i]);
                if (i % 16 == 0)    begin
                    $display();
                end

            end
            
        endfunction
    endclass //cpu_monitor extends uvm_monitor
endpackage