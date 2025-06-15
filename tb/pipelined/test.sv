`include "uvm_macros.svh"
package test_pkg;
    import uvm_pkg::*;
    import env_pkg::*;

    class cpu_test extends uvm_test;
        cpu_env env;
        
        `uvm_component_utils(cpu_test);
        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction //new()

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            env = cpu_env::type_id::create("env", this);

        endfunction


        virtual task automatic run_phase(uvm_phase phase);
            //phase.raise_objection(this);
            $display("===Starting test===");

        endtask //automatic
    endclass //cpu_test extends uvm_test
endpackage