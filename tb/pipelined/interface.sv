interface cpu_if(input bit clk);
    //  DUT signals; Inside top
    logic reset;
    logic [31:0]    WriteData, DataAdr;
    logic           MemWrite;
    logic [3:0]     MemWriteSelect;
    logic [31:0]    ReadData;
    logic [31:0]    PC;
    logic [31:0]    instr;
    //  DUT internal signals

    //  inside riscvsingle
    logic [31:0]    ALUResultE;
    
    clocking monitor_cb @(posedge clk)
        input reset, WriteData, DataAdr, MemWrite, MemWriteSelect, ReadData, PC, instr, ALUResultE;
    endclocking

endinterface //interfacename