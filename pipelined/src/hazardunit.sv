module hazardunit
    #(parameter XLEN = 32)
    (
        input   logic [4:0]             Rs1D, Rs2D, Rs1E, Rs2E,
        input   logic [4:0]             RdE, RdM, RdWB,
        input   logic                   RegWriteM, RegWriteWB,
        input   logic                   UsesRs1D, UsesRs2D,
        input   logic [1:0]             ResultSrcE,
        input   logic                   PCSrcE,
        output  logic                   StallF, StallD,
        output  logic                   FlushE, FlushD,
        output  logic [1:0]             ForwardAE, ForwardBE
    );
    
    //  Forwarding for Data Hazards
    //  SrcA
    always_comb 
        begin
            if ((Rs1E == RdM) & RegWriteM & Rs1E != 0)  //  Don't forward x0, forward if need to write
                ForwardAE = 2'b10;
            else if ((Rs1E == RdWB) & RegWriteWB & Rs1E != 0)
                ForwardAE = 2'b01;
            else
                ForwardAE = 2'b00;
        end
    //  SrcB
    always_comb 
        begin
            if ((Rs2E == RdM) & RegWriteM & Rs2E != 0)  //  Don't forward x0, forward if need to write
                ForwardBE = 2'b10;
            else if ((Rs2E == RdWB) & RegWriteWB & Rs2E != 0)
                ForwardBE = 2'b01;
            else
                ForwardBE = 2'b00;
        end
    
    //  Stall when load hazard, then use the above forwarding logic afterwards
    logic lwStall;
    //  logic to prevent fake stalls
    assign lwStall = (ResultSrcE == 2'b01) & (RdE != 5'b0) &
                        ((UsesRs1D & Rs1D == RdE) | (UsesRs2D & Rs2D == RdE));
    logic StallF, StallD;
    assign StallF = lwStall;
    assign StallD = lwStall;
    
    //  Flush when branch taken or load introduces bubble
    assign FlushD = PCSrcE;
    assign FlushE = PCSrcE | lwStall;
endmodule
