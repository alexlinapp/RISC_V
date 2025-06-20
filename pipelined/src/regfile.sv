module regfile
    #(parameter XLEN = 32)
    (
        input logic                 clk,
        input logic                 we3,
        input logic     [4:0]       a1, a2, a3,
        input logic     [XLEN-1:0]  wd3, 
        output logic    [XLEN-1:0]  rd1, rd2,
        cpu_if intf     //  interface
    );
    
    //  three ported register file
    logic [XLEN-1:0] rf[31:0];
    
    initial begin
        for (int i = 0; i < 32; i++)
            rf[i] = 32'b0;
    end
    
    always_comb begin 
        for (int i = 0; i < 32; i++) begin
            intf.rf[i] = rf[i];
        end
    
    end
    //  write occurs on the negative edge of clk (first half of cycle)
    //  read occurs on second half of cycle
    always_ff @(negedge clk)
        if (we3)
            rf[a3] <= wd3;
    assign rd1 = (a1 != 0) ? rf[a1] : 0;   //  of a1 = 0, zero register by definition holds 0
    assign rd2 = (a2 != 0) ? rf[a2] : 0;
endmodule


module csr_regfile
    (
        input   logic               clk,
        input   logic               we,
        input   logic [11:0]        address,
        input   logic [31:0]        writeData,
        output  logic [31:0]        readData  
    );
    
    logic [31:0] csr_rf [10:0];
    
    initial begin
        for (int i = 0; i < 11; i++) begin
            csr_rf[i] = '0;
        end
    
    end
    
    //  avaiable/write at the end of the cycle
    always_ff @(posedge clk) begin
        if (we)
            csr_rf[address] <= writeData;
    end
    
    assign readData = csr_rf[address];


endmodule