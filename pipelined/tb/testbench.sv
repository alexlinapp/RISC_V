module testbench();
    logic           clk;
    logic           reset;
    logic [31:0]    WriteData, DataAdr;
    logic           MemWrite;
    logic [3:0]     MemWriteSelect;
    
    //  instantiate device to be tested
    top dut(.clk, .reset, .WriteData, .DataAdr, .MemWrite, .MemWriteSelect);
    
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
    initial
        begin
            repeat (20) @(posedge clk);
            $stop;
        
        end
//    always @(negedge clk)
//        begin
//            if (MemWrite)
//                begin
//                    if (DataAdr === 100 && WriteData === 25)
//                        begin
//                            $display("Simulation Success");
//                            #10;
//                            $stop;
//                        end
//                    else if (DataAdr !== 96)
//                        begin
//                            $display("Simulation Failed");
//                            $stop;
//                        end
//                end        
//        end
endmodule
