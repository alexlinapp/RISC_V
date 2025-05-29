/*
Assuming directcache is byte addresable, i.e. byteoffset of 2
writeback cache, using dirty bit
*/
module directcache
    #(parameter N = 3, M = 4)  //  N: number of address bits   M: Number of bytes per word
    (
        input   logic [2**N - 1: 0] addr,
        output  logic [2**N - 1: 0] y
    );
    logic hit;
    
    always_ff
endmodule
