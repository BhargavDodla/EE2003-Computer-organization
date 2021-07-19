module cpu (
    input clk, 
    input reset,
    output [31:0] iaddr,
    input [31:0] idata,
    output [31:0] daddr,
    input [31:0] drdata,
    output [31:0] dwdata,
    output [3:0] dwe
);

    reg  [31:0] iaddr;
    wire [31:0] daddr;
    wire [31:0] dwdata;
    wire [3:0]  dwe;
    wire [31:0] to_reg_data;
    wire [11:0] offset;
    wire we;
    wire [4:0] rs1 ,rs2 ,rd;
    wire [5:0] op;      
    wire [31:0] rv1, rv2, r_rv2, rvout;
    
alu u1(	
        .op(op),
        .rv1(rv1),
        .rv2(rv2),
        .rvout(rvout)
    );

regfile u2(
		.reset(reset),
        .clk(clk),
        .rs1(rs1),  
        .rs2(rs2),
        .rd(rd),
        .we(we),  
		.wdata((idata[4] == 1) ? rvout : to_reg_data),
        .rv1(rv1),
        .rv2(r_rv2)     // Decoder selects between this and Imm
    );

decoder u3(
		.clk(clk),
        .instr(idata),
        .op(op),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .we(we),
        .r_rv2(r_rv2),  // From RegFile
        .rv2(rv2),	// To ALU
        .offset(offset)
    );    

load_store u4(
		.reset(reset),
		.op(op),
		.daddr(daddr),
		.drdata(drdata),
		.dwdata(dwdata),
		.dwe(dwe),
		.to_reg_data(to_reg_data),
		.rv2(r_rv2),
		.rv1(rv1),
		.offset(offset)
	);


    always @(posedge clk) 
    begin
        if (reset) 
        begin
            iaddr <= 0;
        end
        else 
        iaddr = iaddr + 4;
    end



endmodule
