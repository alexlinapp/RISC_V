module dmem
    (
        input   logic           clk,
        input   logic [3:0]     we,
        input   logic [31:0]    a, wd, 
        output  logic [31:0]    rd,
        cpu_if  intf
    );
    logic [31:0] RAM[63:0];     //  64 x 32 memory. 64 addresses, 32 bits stored at each address
    assign rd = RAM[a[31:2]];
    
    initial begin
        for (int i = 0; i < 64; i++) begin
            RAM[i] = 32'b0;
        end
    end
    
    always_ff @(posedge clk) begin
        for (int i = 0; i < 64; i++) begin
            intf.DMEM[i] = RAM[i];
        end
    end
    always_ff @(posedge clk)
        begin
            if (we[3])
                RAM[a[31:2]] <= wd;
            else if (we[1])
                RAM[a[31:2]][8*a[1:0] +:16] <= wd[15:0];
            else if (we[0])
                RAM[a[31:2]][8*a[1:0] +:8] <= wd[7:0];
        end   
                
endmodule
