module tbtop; 
    //import uvm_pkg::*;
    import global_defs_pkg::*;
    import instr_pkg::*;
    import gen_pkg::*;
    //import test_pkg::*;
    bit clk;
    bit reset;
    logic [31:0] IMEM [IMEM_SIZE];
    initial begin
        reset = 1;
        #22;
        reset = 0;
        forever begin
            #5;
            clk = ~clk;
        end
    end
    
    cpu_if intf(clk);
    top cpu(.clk(intf.clk), .WriteData(intf.WriteData), .DataAdr(intf.DataAdr),
            .MemWrite(intf.MemWrite), .MemWriteSelect(intf.MemWriteSelect), .ReadData(intf.ReadData), 
            .instr(intf.instr), .PC(intf.PC), .reset(reset));


    
    initial begin
        automatic int fd = $fopen("C:/Users/NODDL/RISC_V/pipelined/testfiles/testv1.txt", "w");
        if (!fd)
            $fatal(1, "Fatal: Failed to open testfile");
        generateInstructions(fd);
        $fclose(fd);
        $display("Im running???");
        // uvm_config_db#(virtual cpu_if)::set(uvm_root::get(),"*","cpu_if",intf);
        // run_test("cpu_test");
        $finish;
    end

    function automatic void generateInstructions(input int fd);
        Instruction instr = new();
        for (int i = 0; i < IMEM_SIZE; i++) begin
            instr.buildRandomize();
            instr.customRandomize();
            IMEM[i] = instr.getInstruction();
            $fdisplay(fd, "%h", instr.getInstruction());
            $display("i: %0d, instruction: %0h", i, instr.getInstruction());
        end
        
    endfunction
endmodule