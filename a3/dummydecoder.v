module dummydecoder(
    input [31:0] instr,  // Full 32-b instruction
    output [5:0] op,     // some operation encoding of your choice
    output [4:0] rs1,    // First operand
    output [4:0] rs2,    // Second operand
    output [4:0] rd,     // Output reg
    input  [31:0] r_rv2, // From RegFile
    output [31:0] rv2,   // To ALU
    output we            // Write to reg
);


	reg[5:0] op;
	reg[31:0] rv2;
	
	//Instruction decoding (opcode + input and output addresses)

	always@(*)
	begin

	if (instr[5] == 1)	     
	begin
		op = {instr[5], instr[31:30], instr[14:12]};    //opcode extraction
		rv2 = r_rv2;                    //getting value of second operand from memory
	end
	else if ((instr[5] == 0) && ((instr[14:12] == 3'b001) || (instr[14:12] == 3'b101)))
	begin
		op = {instr[5], instr[31:30], instr[14:12]};    //opcode extraction
		rv2 = instr[24:20];        //getting immediate value of second operand from instruction
	end
	else 
	begin
		op = {instr[5], 2'b00, instr[14:12]};          //opcode extraction
		rv2 = instr[31:20];       //getting immediate value of second operand from instruction
	end
	
	end
	
	assign rs1 = instr[19:15];    //getting address for first operand
    assign rs2 = instr[24:20];    //getting address for second operand
    assign rd = instr[11:7];      //getting address for output storage
    assign we = 1;                // For only ALU ops, can always set to 1

endmodule
