module alu32(
    input [5:0] op,      // some input encoding of your choice
    input [31:0] rv1,    // First operand
    input [31:0] rv2,    // Second operand
    output [31:0] rvout  // Output value
);

	reg [31:0] rvout;
	wire [31:0] rv2_imm; 
	assign rv2_imm = {{20{rv2[11]}},rv2[11:0]};   // sign extending the immediate value
	
	// all the ALU instructions implemented according to the corresponding opcode

	always@(*)
	begin
	
	case (op)
		6'h27  :  rvout = rv1 & rv2;
		6'h07  :  rvout = rv1 & rv2_imm;  
		6'h26  :  rvout = rv1 | rv2;
		6'h06  :  rvout = rv1 | rv2_imm;
		6'h20  :  rvout = rv1 + rv2;
		6'h00  :  rvout = rv1 + rv2_imm;
		6'h24  :  rvout = rv1 ^ rv2;
		6'h04  :  rvout = rv1 ^ rv2_imm;
		6'h28  :  rvout = rv1 - rv2;
		6'h21  :  rvout = rv1 << rv2[4:0];
		6'h01  :  rvout = rv1 << rv2[4:0];
		6'h25  :  rvout = rv1 >> rv2[4:0];
		6'h05  :  rvout = rv1 >> rv2[4:0];
		6'h2d  :  rvout = rv1 >>> rv2[4:0];
		6'h15  :  rvout = rv1 >>> rv2[4:0];
		6'h23  :  rvout = (rv1 < rv2) ? 1'b1 : 1'b0;
		6'h03  :  rvout = (rv1 < rv2_imm) ? 1'b1 : 1'b0;
		6'h22  :  rvout = ($signed(rv1) < $signed(rv2) ) ? 1'b1 : 1'b0;
		6'h02  :  rvout = ($signed(rv1) < $signed(rv2_imm) ) ? 1'b1 : 1'b0;
		default: rvout <= 0;
	endcase	
	
	end 
		
endmodule
