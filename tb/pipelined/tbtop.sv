module tbtop; 
    import uvm_pkg::*;
    import test_pkg::*;
    bit clk;
    bit reset;

    initial begin
        clk = 0;
    end

    always begin
        #5;
        clk = ~clk;
    end
    
    cpu_if intf(clk);

    initial begin
        uvm_config_db#(virtual cpu_if)::set(uvm_root::get(),"*","cpu_if",intf);
        run_test("cpu_test");
    end
endmodule