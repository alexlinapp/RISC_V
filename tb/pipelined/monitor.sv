`include "uvm_macros.svh"
package monitor_pkg;
    import global_defs_pkg::*;
    import instr_pkg::*;
    import uvm_pkg::*;
    import gen_pkg::*;
    
    `define MON_IF vif.monitor_cb
    class cpu_monitor extends uvm_monitor;
        // //  DUT Top signals
        // logic           clk, reset,
        // logic [31:0]    WriteData, DataAdr;
        // logic           MemWrite;
        // logic [3:0]     MemWriteSelect;
        // logic [31:0]    ReadData;
        // logic [31:0]    PC;
        // logic [31:0]    instr;
        // //  DUT internal signals

        // //  inside riscvsingle
        // //  necessary for forwarding logic
        // logic [31:0]    ALUResultE;

        virtual cpu_if vif;
        gen_pkg::mon_sb_trans trans;
        uvm_analysis_port #(gen_pkg::mon_sb_trans) trans_collected_port;

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
                
            end
        endtask //automatic

        virtual task automatic collector();
            @`MON_IF;
            
            
        endtask

        virtual function op_t getop();
            ;
            
        endfunction

        /*
        returns: {rs2, rs1, rd}
        */
        virtual function op_t getreg();
            ;
            
        endfunction
        /*

        */
        virtual function op_t getfunct3();
            ;
            
        endfunction
        virtual function op_t getfunct7();
            ;
            
        endfunction
        virtual function int getimm(op_t op, logic [31:0] instr);
            case (op)
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
    endclass //cpu_monitor extends uvm_monitor
endpackage