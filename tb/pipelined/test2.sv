import uvm_pkg::*;

`include "uvm_macros.svh"

program automatic test2();
    initial begin
        $display("TEST");
        `uvm_info ("infol", "Hello World!", UVM_LOW);
    end

endprogram