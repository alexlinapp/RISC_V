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

    logic [31:0]    rf [32];
    
    clocking monitor_cb @(posedge clk);
        input reset; 
        input WriteData; 
        input DataAdr; 
        input MemWrite;
        input MemWriteSelect; 
        input ReadData; 
        input PC; 
        input instr; 
        input ALUResultE;
        input rf;
    endclocking

endinterface //interfacename