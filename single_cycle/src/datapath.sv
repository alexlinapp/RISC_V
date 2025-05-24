module datapath
    (
        input   logic           clk, reset,
        input   logic [1:0]     ResultSrc,
        input   logic           PCSrc, ALUSrc,
        input   logic           RegWrite,
        input   logic [1:0]     immsrc,
        input   logic [2:0]     ALUControl,
        input   logic [31:0]    instr,          
        input   logic [31:0]    ReadData,
        output  logic           Zero,
        output  logic [31:0]    ALUResult, WriteData,
        output  logic [31:0]    PC     
    );
    
    logic [31:0] PCNext, PCPlus4, PCTarget;
    logic [31:0] immext;
    logic [31:0] SrcA, SrcB;
    logic [31:0] Result;
    
    //  PC Next Logic
    dff #(32)   pcreg(.clk, .reset, .d(PCNext), .q(PC));
    adder       pcadd4(.a(PC), .b(32'd4), .y(PCPlus4));
    adder       pcaddbranch(.a(PC), .b(immext), .y(PCTarget));  
    mux2 #(32)  pcmux(.d0(PCPlus4), .d1(PCTarget), .s(PCSrc), .y(PCNext));
    
    //  register file logic
    regfile     rf(.clk, .we3(RegWrite), .a1(instr[19:15]), .a2(instr[24:20]), .a3(instr[11:7]), 
                    .wd3(Result), .rd1(SrcA), .rd2(WriteData));     
                    //  WriteData used here instead SrcB since it is WriteData signal being driven
    extend      ext(.instr(instr[31:7]), .immsrc, .immext);
    
    //  ALU Logic
    mux2 #(32)  srcbmux(.d0(WriteData), .d1(immext), .s(ALUSrc), .y(SrcB));
    alu         alu(.a(SrcA), .b(SrcB), .ALUControl, .ALUResult, .Zero);
    mux3 #(32)  resultmux(.d0(ALUResult), .d1(ReadData), 
                            .d2(PCPlus4), .s(ResultSrc), .y(Result));  
                            
                                           
endmodule
