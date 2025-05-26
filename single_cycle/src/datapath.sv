module datapath
    (
        input   logic           clk, reset,
        input   logic [1:0]     ResultSrc,
        input   logic           PCSrc, ALUSrc,
        input   logic           RegWrite,
        input   logic           JumpALR,
        input   logic [1:0]     immsrc,
        input   logic [3:0]     ALUControl,
        input   logic [31:0]    instr,          
        input   logic [31:0]    ReadData,
        output  logic           Zero, LessThan, LessThanUnsigned,
        output  logic [31:0]    ALUResult, WriteData,
        output  logic [31:0]    PC     
    );
    
    logic [31:0] PCNext, PCPlus4, PCTarget, PCTargetJ;
    logic [31:0] immext;
    logic [31:0] SrcA, SrcB;
    logic [31:0] Result;
    logic [31:0] ReadDataSelected;
    
    //  PC Next Logic
    dff #(32)   pcreg(.clk, .reset, .d(PCNext), .q(PC));
    adder       pcadd4(.a(PC), .b(32'b100), .y(PCPlus4));
    adder       pcaddbranch(.a(PC), .b(immext), .y(PCTarget));  
    mux2 #(32)  pcmux(.d0(PCPlus4), .d1(PCTargetJ), .s(PCSrc), .y(PCNext));
    mux2 #(32)  pcJmux(.d0(PCTarget), .d1(ALUResult), .s(JumpALR), .y(PCTargetJ));
    //  register file logic
    regfile     rf(.clk, .we3(RegWrite), .a1(instr[19:15]), .a2(instr[24:20]), .a3(instr[11:7]), 
                    .wd3(Result), .rd1(SrcA), .rd2(WriteData));     
                    //  WriteData used here instead SrcB since it is WriteData signal being driven
    extend      ext(.instr(instr[31:7]), .immsrc, .immext);
    
    
    //  ALU Logic
    mux2 #(32)  srcbmux(.d0(WriteData), .d1(immext), .s(ALUSrc), .y(SrcB));
    alu         alu(.a(SrcA), .b(SrcB), .ALUControl, .ALUResult, .Zero,
                    .LessThan, .LessThanUnsigned);
    mux3 #(32)  resultmux(.d0(ALUResult), .d1(ReadDataSelected), 
                            .d2(PCPlus4), .s(ResultSrc), .y(Result));  
    dmemselect  dmemselect1(.ReadData, .funct3(instr[14:12]), .ReadDataSelected);  
                          
                                           
endmodule
