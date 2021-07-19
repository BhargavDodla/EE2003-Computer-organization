module regfile(
    input [4:0] rs1,     // address of first operand to read - 5 bits
    input [4:0] rs2,     // address of second operand
    input [4:0] rd,      // address of value to write
    input we,            // should write update occur
    input [31:0] wdata,  // value to be written
    output [31:0] rv1,   // First read value
    output [31:0] rv2,   // Second read value
    input clk            // Clock signal - all changes at clock posedge
);

	reg [31:0] mem[0:31];    // memory block 32 registers of 32 bit length
	integer i;
    // Desired function
    // rv1, rv2 are combinational outputs - they will update whenever rs1, rs2 change
    // on clock edge, if we=1, regfile entry for rd will be updated 
    initial      // Setting all the registers to 0 in the beginning
    begin 
    for(i = 0;i < 32 ;i = i + 1)
        mem[i] = 32'b0;
	end
    assign rv1 = mem[rs1];    //getting the register from address rs1 combinationally
    assign rv2 = mem[rs2];	  //getting the register from address rs2 combinationally
    always @(posedge clk)
    begin
    if(we)
    	mem[rd] <= wdata;     //writing the output at the specified address(synchronously)
    end

endmodule
