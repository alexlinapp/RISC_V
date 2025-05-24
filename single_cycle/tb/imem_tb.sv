module imem_tb();
    localparam T = 20;  //  clock period
    logic clk, reset;
    logic [31:0] a, rd;
    
    imem imem0(.a, .rd);
    initial
        begin
            a = -1;
        end
    always
        begin
            clk = 1;
            #(T/2);
            clk = 0;
            #(T/2);
        
        end
    always @(negedge clk)
        begin
           a = a + 1; 
           if (a == 84)
            begin
                $display("FINISHED");
                $stop;
            end
        end
endmodule
