module dmem
    (
        input   logic           clk, we,
        input   logic [31:0]    a, wd, 
        output  logic [31:0]    rd
    );
    logic [31:0] RAM[63:0];     //  64 x 32 memory. 64 addresses, 32 bits stored at each address
    assign rd = RAM[a[31:2]];
    always_ff @(posedge clk)
        if (we)
            RAM[a[31:2]] <= wd; //  RISC-V is technically byte addressable but we make it only
                                //  word addresable here. Will add that functionality later
    
            
endmodule
