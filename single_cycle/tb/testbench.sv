module testbench();
    logic           clk;
    logic           reset;
    logic [31:0]    WriteData, DataAdr;
    logic           MemWrite;
    
    //  instantiate device to be tested
    top dut(.clk, .reset, .WriteData, .DataAdr, .MemWrite);
    
    //  initialize test
    initial
        begin
            reset <= 1;
            # 22;
            reset <= 0;
        end
    
    //  generating clock
    always
        begin
            clk = 1;
            #5;
            clk = 0;
            #5;
        end
    
    //  verify results
    always @(negedge clk)
        begin
            $display("test");
            if (MemWrite)
                begin
                    if (DataAdr === 100 && WriteData === 25)
                        begin
                            $display("Simulation Success");
                            $stop;
                        end
                    else if (DataAdr !== 96)
                        begin
                            $display("Simulation Failed");
                            $stop;
                        end
                end        
        end
endmodule
