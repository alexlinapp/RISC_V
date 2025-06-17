module top
    //  to be used with the test bench
    
    //
    (
        input   logic           clk, reset,
        output  logic [31:0]    WriteData, DataAdr,
        output  logic           MemWrite,
        output  logic [3:0]     MemWriteSelect,
        output  logic [31:0]    PC, instr, ReadData,
        cpu_if intf //  part of TB
    );
    
    //logic [31:0] PC, instr, ReadData;
    
    //  instantiate processor and memories
    riscvsingle rvsingle(.clk, .reset, .PC, .instr,
                        .MemWrite, .MemWriteSelect, .ALUResult(DataAdr), .WriteData, .ReadData,
                        .intf);
    imem imem(.a(PC), .rd(instr));
    dmem dmem(.clk, .we(MemWriteSelect), .a(DataAdr), .wd(WriteData), .rd(ReadData), .intf);
endmodule
