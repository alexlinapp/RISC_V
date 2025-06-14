module alu
    #(parameter XLEN = 32)
    (
        input   logic [XLEN-1:0]    a, b,
        input   logic [3:0]         ALUControl,
        output  logic [XLEN-1:0]    ALUResult, 
        output  logic               Zero, LessThan, LessThanUnsigned
    );
    logic [3:0]         flags;
    logic [XLEN-1:0]    condinvb, sum;
    logic               v, c, n, z; //  flags: overflow, carry out, negative, zero
    logic               cout;       //  carry out of adder
    logic               isAddSub;
    //  logic here so addition is only performed once
    assign flags = {v, c, n, z};
    assign condinvb = ALUControl[0] ? ~b : b;   //  selecting to perform addition or subtraction
    assign {cout, sum} = a + condinvb + ALUControl[0];
    assign isAddSub = ~ALUControl[3] & ~ALUControl[2] & ~ALUControl[1] | 
                       ~ALUControl[3] & ~ALUControl[1] & ALUControl[0];
    always_comb
        case(ALUControl)
            4'b0000:    ALUResult = sum;            //  add
            4'b0001:    ALUResult = sum;            //  sub
            4'b0010:    ALUResult = a & b;          //  and
            4'b0011:    ALUResult = a | b;          //  or
            4'b0100:    ALUResult = a ^ b;          //  XOR
            4'b0101:    ALUResult = sum[XLEN-1] ^ v;    //  slt
            4'b0110:    ALUResult = a >> b[4:0];         //  srl
            4'b0111:    ALUResult = $signed(a) >>> b[4:0];   //  sra
            4'b1000:    ALUResult = a << b;         //  sll
            4'b1001:    ALUResult = {'0, ~cout};          //  sltu   
            default:    ALUResult = 'x;    
        endcase
    assign z = (ALUResult == 32'b0);
    assign n = ALUResult[XLEN-1];
    assign c = cout & isAddSub;
    assign v = isAddSub & (a[XLEN-1] ^ sum[XLEN-1]) & ~(ALUControl[0] ^ a[XLEN-1] ^ b[XLEN-1]);
    //  output signals
    assign Zero = z;
    assign LessThan = n ^ v;
    assign LessThanUnsigned = ~c;
endmodule
