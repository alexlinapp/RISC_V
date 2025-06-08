import gen::*;
import global_defs_pkg::*;
import instr_pkg::*;


program automatic test1;
    Instruction instr;
    bit signed [31:0] PC;
    initial begin
        automatic int fd = $fopen("../../tb/pipelined/instr1.txt", "w");
        if (fd == 0) begin
            $display("Failed to open file.");
            $finish;
        end
        instr = new();
        for (int i = 0; i < IMEM_SIZE; i++) begin
            $fdisplay(fd, "%h", instr.getInstruction(PC));
        end

        $fclose(fd);
        $display("FINSIHEIHASKDS");
    end

endprogram