module alu_updated_tb();
    logic clk, reset;
    logic [3:0]     a, b, ALUResult;
    logic [6:0]     resultexpected;
    logic [3:0]     ALUControl;
    logic           Zero, LessThan, LessThanUnsigned;
    
    
    alu #(.XLEN(4)) uut(.a, .b, .ALUControl, .ALUResult, .Zero, .LessThan, .LessThanUnsigned);
    logic [31:0] vectornum, errors;
    logic [18:0] testvectors[10:0];
    always
        begin
            clk = 1;
            #5;
            clk = 0;
            #5;
        end
    initial
        begin
            $readmemb("C:/Users/NODDL/RISC_V/common/testfiles/ALUtest1.txt", testvectors);
            vectornum = 0;
            errors = 0;
            reset = 1; 
            #22;
            reset = 0;
        end
     
     always @(posedge clk)
        begin
            {ALUControl, a, b, resultexpected} = testvectors[vectornum];
        end
     always @(negedge clk)
        begin
            if (~reset)
                begin
                    if (ALUResult !== resultexpected[6:3])
                        begin
                            casez(ALUControl)
                                4'b0001: if (Zero !== resultexpected[2] | LessThan !== resultexpected[1] | LessThanUnsigned !== resultexpected[0])
                                             begin
                                                $display("Error: inputs: a = %b, b = %b, ALUControl = %b,", a, b, ALUControl);
                                                errors = errors + 1;
                                             end
                             endcase                      
                        end
                        vectornum = vectornum + 1;    
                end
                if (testvectors[vectornum] === 'x)
                    begin
                        $display("%d tests completed with %d errors", vectornum, errors);
                        $stop;
                    end
        end
endmodule
