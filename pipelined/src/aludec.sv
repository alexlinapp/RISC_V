module aludec
    (
        input logic         opb5,
        input logic [2:0]   funct3,
        input logic         funct7b5,
        input logic [1:0]   ALUOp,
        output logic [3:0]  ALUControl
    );
    logic RtypeSub;
    assign RtypeSub = funct7b5 & opb5;  //  TRUE for R-type subtract
    
    always_comb
        case(ALUOp)
            2'b00:      ALUControl = 4'b000;    //  addition for loads and stores
            2'b01:      ALUControl = 4'b0001;   //  subtraction for Branch
            default:    case(funct3)            //  R-type or I-type ALU    
                            3'b000:     if (RtypeSub)
                                            ALUControl = 4'b001;    //  sub
                                        else
                                            ALUControl = 4'b000;    //  add, addi
                            3'b001:     ALUControl = 4'b1000;       //  sll
                            3'b010:     ALUControl = 4'b101;        //  slt, slti
                            3'b011:     ALUControl = 4'b1001;       //  sltu
                            3'b100:     ALUControl = 4'b100;        //  xor
                            3'b101:     if (funct7b5)   
                                            ALUControl = 4'b0111;   //  sra
                                        else
                                            ALUControl = 4'b0110;   //  srl
                            3'b110:     ALUControl = 4'b011;        //  or, ori
                            3'b111:     ALUControl = 4'b010;        //  and, andi
                            default:    ALUControl = 4'bxxx;        //  ???
                        endcase
                        
        endcase       
endmodule
