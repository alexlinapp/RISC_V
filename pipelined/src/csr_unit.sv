module lu
    (
        input   logic [31:0]    a,  //  a will always be csr
        input   logic [31:0]    b,  //  b will always be rs1 or uimm
        input   logic [31:0]    funct3,
        output  logic [31:0]    csrData,
        output  logic [31:0]    regData
    );
    logic [31:0] uimm;
    assign uimm = {27'b0, b[4:0]};
    always_comb begin
        regData = a;
        case(funct3)
        3'b001: csrData = b;
        3'b010: csrData = a | b;
        3'b011: csrData = a & ~b;
        3'b101: csrData = uimm;
        3'b110: csrData = a | uimm;
        3'b111: csrData = a & ~uimm;
        default: y = 'x;  
    endcase
    
    end
    
    
endmodule


