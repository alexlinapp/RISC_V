module datapath
    #(parameter XLEN = 32)
    (
        input   logic           clk, reset,
        input   logic [2:0]     ResultSrcD,
        input   logic           ALUSrcD,
        input   logic           RegWriteD,
        input   logic           JumpALRD, JumpD, BranchD,
        input   logic [2:0]     immsrcD,
        input   logic [3:0]     ALUControlD,
        input   logic [31:0]    instrF, 
        input   logic           MemWriteD, 
        input   logic [31:0]    ReadDataM, 
        input   logic           UsesRs1D, UsesRs2D, 
        input   logic           CSRWriteD,      
        output  logic [31:0]    ALUResultM, WriteDataM,
        output  logic [31:0]    PC,     
        output  logic           MemWrite,
        output  logic [3:0]     MemWriteSelect,
        output  logic [31:0]    instrD,
        cpu_if intf //  part of interface
    );
    
    //  pipelines: Fetch->Decode->Execute->Memory->WriteBack
    
     
    
    //  instruction fetch signals
    logic [31:0] PCNextF, PCPlus4F, PCTargetJF;
    
    //  instruction decode signals
    logic [31:0]    RD1D, RD2D;
    logic [31:0]    PCD;
    logic [4:0]     Rs1D, Rs2D, RdD;
    logic [31:0]    immextD;
    logic [31:0]    PCPlus4D;
    assign Rs1D = instrD[19:15];
    assign Rs2D = instrD[24:20];
    assign RdD = instrD[11:7];
    
    //  instruction execute signals
    logic               RegWriteE, MemWriteE;
    logic [2:0]         ResultSrcE;
    logic               JumpE, JumpALRE, BranchE;
    logic [3:0]         ALUControlE;
    logic               ALUSrcE;
    logic [2:0]         funct3E;
    logic               ZeroE, LessThanE, LessThanUnsignedE;
    logic               BranchCE;
    logic [XLEN-1:0]    PCE, PCPlus4E;
    logic [4:0]         Rs1E, Rs2E, RdE;
    logic [XLEN-1:0]    WriteDataE;
    logic [XLEN-1:0]    RD1E, RD2E;
    logic [XLEN-1:0]    ALUResultE;
    logic               op5E;
    
    logic               PCSrcE;
    logic [31:0]        immextE;
    logic [XLEN-1:0]    SrcAE, SrcBE;
    logic [XLEN-1:0]    PCTargetE;
    logic [XLEN-1:0]    ResultUE;
    logic               CSRWriteE;
    logic [XLEN-1:0]    CSRSrcAE, CSRSrcBE;
    logic [XLEN-1:0]    CSRDataE, CSRRegDataE;
    logic [XLEN-1:0]    CSRRDE;
    
    // instruction memory signals
    logic               RegWriteM, MemWriteM;
    logic [2:0]         ResultSrcM;
    //logic [2:0]         ResultSrcM1;
    logic [4:0]         RdM;
    logic [XLEN-1:0]    PCPlus4M, PCTargetM;
    logic [2:0]         funct3M;
    
    logic [3:0]         MemWriteSelectM;
    
    logic [31:0]        ReadDataSelectedM;
    logic [XLEN-1:0]    ResultUM, ResultM;
    logic [XLEN-1:0]    CSRRegDataM;
        //  result signal assignment
    logic [31:0] dResultM [7:0];    
    
    // instruction write back signals
    logic               RegWriteWB;
    logic [4:0]         RdWB;
    logic [XLEN-1:0]    ResultWB;
    //  Hazard Unit Signal Declaration
    logic StallF, StallD, FlushD, FlushE;
    logic [1:0] ForwardAE, ForwardBE; 
    
    
    //  Instruction Fetch Stage
    //  PC Next Logic, PC = PCF
    dff_nen #(32)   pcreg(.clk, .reset, .en(StallF), .d(PCNextF), .q(PC));
    adder       pcadd4(.a(PC), .b(32'b100), .y(PCPlus4F));
    adder       pcaddbranch(.a(PCE), .b(immextE), .y(PCTargetE));  
    mux2 #(32)  pcmux(.d0(PCPlus4F), .d1(PCTargetJF), .s(PCSrcE), .y(PCNextF));
    mux2 #(32)  pcJmux(.d0(PCTargetE), .d1(ALUResultE), .s(JumpALRE), .y(PCTargetJF));
    
    
    
    
    //  Instruction Decode Stage
    
    
    //  register file logic
    regfile     rf(.clk, .we3(RegWriteWB), .a1(instrD[19:15]), .a2(instrD[24:20]), .a3(RdWB), 
                    .wd3(ResultWB), .rd1(RD1D), .rd2(RD2D), .intf);     
          
    extend      ext(.instr(instrD[31:7]), .immsrc(immsrcD), .immext(immextD));
    
    //  CSR register file
    
    csr_regfile csr_rf(.clk, .we(CSRWriteE), .address(immextE[11:0]), .writeData(CSRDataE),
                        .readData(CSRRDE));
    
    
    
    
    
    
    
    //  execute stage
    //  ALU Logic
    
    mux2 #(32)  srcbmux(.d0(WriteDataE), .d1(immextE), .s(ALUSrcE), .y(SrcBE));
    alu         alu1(.a(SrcAE), .b(SrcBE), .ALUControl(ALUControlE), .ALUResult(ALUResultE), 
                    .Zero(ZeroE), .LessThan(LessThanE), .LessThanUnsigned(LessThanUnsignedE));
    //  forwarding muxes
    mux4 #(32)  forwardbmux(.d0(RD2E), .d1(ResultWB), .d2(ResultM), .s(ForwardBE), .y(WriteDataE));
    mux4 #(32)  forwardamux(.d0(RD1E), .d1(ResultWB), .d2(ResultM), .s(ForwardAE), .y(SrcAE));
    //  branch decode logic
    
    branchdec bd(.Zero(ZeroE), .LessThan(LessThanE), .LessThanUnsigned(LessThanUnsignedE), 
                    .funct3(funct3E), .BranchC(BranchCE));
    assign PCSrcE = BranchE & BranchCE | JumpE;        //  Replaced Zero with BranchC, where BranchC is the actual condition                     
    
    
    //  U-Type Logic instr[5] = opb5
    mux2 #(32) resultUmux(.d0(PCTargetE), .d1(immextE), .s(op5E), .y(ResultUE));
    
    //  CSR logic
        //  put in the execute and not memory stage since not using ALU
    mux2 #(32) CSRmux(.d0(SrcAE), .d1(Rs1E), .s(funct3E[2]), .y(CSRSrcBE));
    lu CSRlu(.a(CSRRDE), .b(CSRSrcBE), .funct3(funct3E), 
                .csrData(CSRDataE), .regData(CSRRegDataE));
    
    
    //  memory stage
    assign MemWrite = MemWriteM;
    assign MemWriteSelect = MemWriteSelectM;
    
    //  test code
//    logic [31:0] ResultM1;
//    assign ResultSrcM1 = ResultSrcM;
    always_comb begin
        dResultM[0] = ALUResultM;
        dResultM[1] = ReadDataSelectedM;
        dResultM[2] = PCPlus4M;
        dResultM[3] = ResultUM;
        dResultM[4] = CSRRegDataM;
    end
    mux8 #(32)  resultmux(.d(dResultM), .s(ResultSrcM), .y(ResultM));
//    mux4 #(32)  resultmux(.d0(ALUResultM), .d1(ReadDataSelectedM), 
//                            .d2(PCPlus4M), .d3(ResultUM), .s(ResultSrcM), .y(ResultM)); 
    //  for writing into data memory
    memdec memd(.MemWrite(MemWriteM), .funct3(funct3M), .MemWriteSelect(MemWriteSelectM));
    //  for reading from data memory and into register
    dmemselect  dmemselect1(.ALUResultM, .ReadData(ReadDataM), .funct3(funct3M), 
                            .ReadDataSelected(ReadDataSelectedM));  
    
    
      
    
    
    //  writeback stage, none need, no components in this stage, uses other components
    
    
    
    
    //  Hazard Unit     
    
    
    hazardunit HU(.*, .CSRAddress(immextE[11:0]));
    // temp values for now
//    assign StallD = 0;
//    assign StallF = 0;
//    assign ForwardAE = 2'b00;
//    assign ForwardBE = 2'b00;
    //  pipeline registers
    IF_ID_REG   IFIDREG(.clk, .clr(FlushD), .en(StallD), .instrF, .PCF(PC), .PCPlus4F,
                        .instrD, .PCD, .PCPlus4D, .reset);
    ID_EX_REG   IDEXREG(.clk, .clr(FlushE), .funct3D(instrD[14:12]), 
                        .op5D(instrD[5]), .*);
    EX_MEM_REG  EXMEMREG(.*);
    MEM_WB_REG  MEMWBREG(.*);
    
      
endmodule
