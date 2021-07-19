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

    wire [31:0] iaddr;
    wire [31:0] daddr;
    wire [31:0] dwdata;
    wire [3:0]  dwe;
    wire [31:0] to_reg_data;
    wire [19:0] offset;
    wire we;
    wire [4:0] rs1 ,rs2 ,rd;
    wire [5:0] op;      
    wire [31:0] rv1, rv2, r_rv2, rvout;
    wire [31:0] link_reg;
    
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
		.wdata(rvout + to_reg_data + link_reg),
        .rv1(rv1),
        .rv2(r_rv2)     // Decoder selects between this and Imm
    );

decoder u3(
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
		.offset(offset[11:0])
	);


branching u5(
		.clk(clk),
		.reset(reset),
		.op(op),
		.offset(offset),
		.rv1(rv1),
		.rv2(r_rv2),
		.iaddr(iaddr),
		.link_reg(link_reg)
);	


endmodule
