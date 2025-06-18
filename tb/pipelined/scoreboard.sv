`include "uvm_macros.svh"
package scoreboard_pkg;
    import uvm_pkg::*;
    import global_defs_pkg::*;
    import instr_pkg::*;
    import reference_model_pkg::*;
    import monitor_pkg::*;

    class cpu_scoreboard extends uvm_scoreboard;
        
        //  queue that holds instructions
        mon_sb_trans q[$] = {null, null, null, null};
        //  writeback, memory, execute, decode
        mon_sb_trans front;
        //  internal state of scoreboard
        // logic [31:0] rf [32];
        // logic [31:0] DMEM [DMEM_SIZE];
        reference_model ref_model;

        uvm_analysis_imp#(instr_pkg::mon_sb_trans, cpu_scoreboard) trans_collected_export;

        int count = 100;
        `uvm_component_utils(cpu_scoreboard)
        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction //new()

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            trans_collected_export = new("item_collected_export", this);
            ref_model = new();
        endfunction

        virtual function automatic void write(mon_sb_trans item);
            $display("Output from CPU Recieved");
            $display("instr: %0h", item.instr);
            if (!$isunknown(item.instr)) begin
                mon_sb_trans tmp;
                if ($cast(tmp, item.clone())) begin
                    q.push_back(tmp);
                end                
                //$display("Pushed back %0h", item.instr);
            end
            front = q.pop_front();
            if (front) begin
                $display("Instruction in Writeback: %0h", front.instr);
                update_sb_WB(front.instr);
                //compare_WB(item, front.instr);  //  using the instruction frmo the pipeiline while item is current state
                check_OP(item);
            end
            else begin
                $display("Preloaded Instruction:");
            end
            $display("Size of queue: %0d", q.size());
            count--;
            
        endfunction

        // virtual function void compare_EX(input mon_sb_trans item , logic [31:0] instr);
        //     case (getop(item.instr))
        //         OP_LOAD  : assert (check_OP_LOAD(item, instr)) 
        //         else   $fatal(1, "Failed: %0s", getop(item.instr).name());   
        //         OP_IMM   : assert (check_OP_IMM(item, instr)) 
        //         else   $fatal(1, "Failed: %0s", getop(item.instr).name());   
        //         OP_STORE : assert (check_OP_STORE(item, instr)) 
        //         else   $fatal(1, "Failed: %0s", getop(item.instr).name());    
        //         OP_R     : assert (check_OP_R(item, instr)) 
        //         else   $fatal(1, "Failed: %0s", getop(item.instr).name());       
        //         OP_B     : assert (check_OP_B(item, instr)) 
        //         else   $fatal(1, "Failed: %0s", getop(item.instr).name());    
        //         OP_JAL   : assert (check_OP_JAL(item, instr)) 
        //         else   $fatal(1, "Failed: %0s", getop(item.instr).name());    
        //         OP_JALR  : assert (check_OP_JALR(item, instr)) 
        //         else   $fatal(1, "Failed: %0s", getop(item.instr).name());    
        //         OP_AUIPC : assert (check_OP_AUIPC(item, instr)) 
        //         else   $fatal(1, "Failed: %0s", getop(item.instr).name());    
        //         OP_LUI   : assert (check_OP_LUI(item, instr)) 
        //         else   $fatal(1, "Failed: %0s", getop(item.instr).name());    
        //         OP_BUBBLE: assert(true);               
        //     endcase
            
        // endfunction

        // virtual function void compare_MEM(input mon_sb_trans item, logic [31:0] instr);
        //     case (getop(item.instr))
        //         OP_LOAD  : assert(true);   
        //         OP_IMM   : assert(true);
        //         OP_STORE : assert (check_OP_STORE(item)) 
        //         else   $fatal(1, "Failed: %0s", getop(item.instr).name());    
        //         OP_R     : assert(true);    
        //         OP_B     : assert(true);    
        //         OP_JAL   : assert(true);    
        //         OP_JALR  : assert(true);  
        //         OP_AUIPC : assert(true);    
        //         OP_LUI   : assert(true);    
        //         OP_BUBBLE: assert(true);               
        //     endcase
            
        // endfunction


        virtual function void update_sb_WB(logic [31:0] instr);
            
            //  timing works out since we write back to rf on a falling edge
      
            ref_model.expected_output(instr);
            
        endfunction

        //  old/depreceated
        // virtual function int update_sb_OP_LOAD(logic [31:0] instr);
        //     case(instr_pkg::getfunct3(instr)) 
        //         3'b000: rf[getreg(instr, 0)] = $signed(DMEM[getAddress(instr, rf)][7:0]);

        //         3'b001: rf[getreg(instr, 0)] = $signed(DMEM[getAddress(instr, rf)][15:0]);
            
        //         3'b010: rf[getreg(instr, 0)] = DMEM[getAddress(instr, rf)];
                

        //         3'b100: rf[getreg(instr, 0)] = {24'b0, DMEM[getAddress(instr, rf)][7:0]};

        //         3'b101: rf[getreg(instr, 0)] = {16'b0, DMEM[getAddress(instr, rf)][15:0]};
                    
        //         default: $fatal(1, "Incorrect funct3 field of %0s", getop(instr).name());
        //     endcase
        //     return 1;   //  failed to update
        // endfunction

    









        // virtual function void compare(mons_sb_trans item);
        // virtual function void compare_WB(input mon_sb_trans item , logic [31:0] instr);
        //     int check = 0;
        //     case (getop(instr))
        //         OP_LOAD  : check = check_OP_LOAD(item, instr);     //  timing works out since we write back to rf on a falling edge
        //         OP_IMM   : check = check_OP_IMM(item, instr);
        //         OP_STORE : assert(1);    
        //         OP_R     : assert (check_OP_R(item)) 
        //         else   $fatal(1, "Failed: %0s", getop(item.instr).name());       
        //         OP_B     : assert (check_OP_B(item)) 
        //         else   $fatal(1, "Failed: %0s", getop(item.instr).name());    
        //         OP_JAL   : assert (check_OP_JAL(item)) 
        //         else   $fatal(1, "Failed: %0s", getop(item.instr).name());    
        //         OP_JALR  : assert (check_OP_JALR(item)) 
        //         else   $fatal(1, "Failed: %0s", getop(item.instr).name());    
        //         OP_AUIPC : assert (check_OP_AUIPC(item)) 
        //         else   $fatal(1, "Failed: %0s", getop(item.instr).name());    
        //         OP_LUI   : assert (check_OP_LUI(item)) 
        //         else   $fatal(1, "Failed: %0s", getop(item.instr).name());    
        //         OP_BUBBLE: check = 1;               
        //     endcase
        //     assert(check)
        //     else  $fatal(1, "Failed: %0s", getop(instr).name());  
        // endfunction



        
        virtual function int check_OP(input mon_sb_trans item);
            foreach(item.rf[i]) begin
                assert(item.rf[i] === ref_model.rf[i])
                else $fatal(1, "Error: Register %0d: Expected: %0d: Output: %0d", i, ref_model.rf[i], item.rf[i]);
            end
            foreach(item.DMEM[i]) begin
                assert(item.rf[i] === ref_model.rf[i])
                else $fatal(1, "Error: Memory %0d: Expected: %0d: Output: %0d", i * 4, ref_model.DMEM[i], item.DMEM[i]);
            end
            return 1;
        endfunction

        //  Depreceated


        // virtual function int check_OP_LOAD(input mon_sb_trans item , logic [31:0] instr);
        //     //$display("This is getreg: %0d", getreg(instr, 0));
        //     assert (item.rf[getreg(instr, 0)] === ref_model.rf[getreg(instr, 0)]) 
        //     else   $fatal(1, "Failed: %0s: Expected: %0h \t Actual: %0h", getop(instr).name(), ref_model.rf[getreg(instr, 0)], item.rf[getreg(instr, 0)]);    //  return error code of 0 if fialed
        //     return 1;
        // endfunction

        // virtual function int check_OP_IMM(input mon_sb_trans item , logic [31:0] instr);
        //     $display("Check op: rf: %0d, rfval: %0d  itemval: %0d", getreg(instr, 0), ref_model.rf[getreg(instr, 0)], item.rf[getreg(instr, 0)]);
        //     return ref_model.rf[getreg(instr, 0)] == item.rf[getreg(instr, 0)];
            
        // endfunction
        // virtual function int check_OP_STORE(input mon_sb_trans item);
        //     return 1;
            
        // endfunction
        // virtual function int check_OP_R(input mon_sb_trans item);
        //     return 1;
            
        // endfunction
        // virtual function int check_OP_B(input mon_sb_trans item);
        //     return 1;
            
        // endfunction
        // virtual function int check_OP_JAL(input mon_sb_trans item);
        //     return 1;
            
        // endfunction
        // virtual function int check_OP_JALR(input mon_sb_trans item);
        //     return 1;
            
        // endfunction
        // virtual function int check_OP_AUIPC(input mon_sb_trans item);
        //     return 1;
            
        // endfunction
        // virtual function int check_OP_LUI(input mon_sb_trans item);
        //     return 1;
            
        // endfunction
            
        // endfunction

        virtual task run_phase(uvm_phase phase);
            //super.run_phase(phase);
            phase.raise_objection(this);
            wait (q.size() == 0 || count <= 0); // clean wait, need to prevent infinite loops as well
            $display("====Final Reg Values=====");
            foreach(ref_model.rf[i]) begin
                $write("Reg %0d: %0h \t", i, ref_model.rf[i]);
            end
            $display("====Final Mem Values====");
            foreach(ref_model.DMEM[i]) begin
                $write("DMEM[%0d]: %0h \t", i * 4, ref_model.DMEM[i]);
            end
            phase.drop_objection(this);
            $display("===Ending Test===");
        endtask
    endclass //cpu_sb extends uvm_score
endpackage