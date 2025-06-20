`include "uvm_macros.svh"
package env_pkg;
    import uvm_pkg::*;
    import monitor_pkg::*;
    import scoreboard_pkg::*;
    import coverage_pkg::*;
    class cpu_env extends uvm_env;
        cpu_monitor monitor;
        cpu_scoreboard scoreboard;
        cpu_coverage coverage;
        `uvm_component_utils(cpu_env)


        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction //new()

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            monitor = cpu_monitor::type_id::create("monitor", this);
            scoreboard = cpu_scoreboard::type_id::create("scoreboard", this);
            coverage = cpu_coverage::type_id::create("coverage", this);  
        endfunction

        function void connect_phase(uvm_phase phase);
            monitor.trans_collected_port.connect(scoreboard.trans_collected_export);
            monitor.trans_collected_port.connect(coverage.trans_coverage_export);
        endfunction
    endclass //cpu_env extends superClass
endpackage