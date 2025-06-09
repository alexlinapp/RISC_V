package reference_model_pkg;
    import global_defs_pkg::*;
    import instr_pkg::*;

    class reference_model;
        logic [XLEN-1:0] rf [31:0];     // register file
        logic [XLEN-1:0] IMEM [IMEM_SIZE], DMEM [DMEM_SIZE];
        logic [31:0] PC;
        function new();
            foreach (rf[i])
                rf[i] = '0;
            foreach (IMEM[i])
                IMEM[i] = '0;
            foreach (DMEM[i])
                DMEM[i] = '0;
            PC = '0;
        endfunction //new()

        function expected_output(ref logic [31:0] instr);
            if (instr[])
            
        endfunction
    endclass //reference_model
    
endpackage