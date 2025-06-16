import gen_pkg::*;
import global_defs_pkg::*;
import instr_pkg::*;


program automatic test1;
    Instruction instr;
    bit signed [31:0] PC;
    logic [31:0] IMEM [IMEM_SIZE];
    int branchNum;
    initial begin
        automatic int fd = $fopen("../../tb/pipelined/instr1.txt", "w");
        if (fd == 0) begin
            $display("Failed to open file.");
            $finish;
        end
        branchNum = 0;
        instr = new();
        //instr.funct7_c.constraint_mode(0);
        //instr.funct3_c.constraint_mode(0);
        //instr.reg_c.constraint_mode(0);
        for (int i = 0; i < IMEM_SIZE; i++) begin
            instr.buildRandomize(PC);
            instr.customRandomize();
            // $write("PC: %0d\t", PC);
            $write("Opcode: %0d", instr.op);
            $display;
            if (instr.op == OP_B) begin
                branchNum++;
                $display("Instruction BRANCH: %0d", i);
            end
                
            IMEM[i] = instr.getInstruction();
            $fdisplay(fd, "%h", instr.getInstruction());
            //PC += 4;
        end

        $fclose(fd);
        $display("FINSIHEIHASKDS: BRANCHES: %0d", branchNum);
        
    end

endprogram