module imem
    (
        input   logic [31:0]    a,
        output  logic [31:0]    rd
    );
    logic [31:0] RAM[63:0];     // 64 x 32 memory
    initial
        $readmemh("C:/Users/NODDL/RISC_V/pipelined/testfiles/csrtest1.txt", RAM);
    assign rd = RAM[a[31:2]];   //  word aligned
endmodule
