module regfile(
	input reset,
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
	wire [31:0] rv1 ,rv2;
	integer i;
/*
	always@(*)
	begin
	
	if(reset)
	begin
	rv1 = 0;
	rv2 = 0;
    for(i = 0;i < 32 ;i = i + 1)
    	mem[i] = 32'b0;
	end
	
	else
	begin
	rv1 = mem[rs1];
	rv2 = mem[rs2];
	end
	
	end    */
	

	always@(*)
	begin
	
	if(reset)
	begin
    for(i = 0;i < 32 ;i = i + 1)
    	mem[i] = 32'b0;
	end
	end  

    always @(posedge clk )
    begin
    
	if (rd == 0)
	mem[0] = 0;
    else 
    begin
    if(we && (!reset))
    	mem[rd] = wdata;     //writing the output at the specified address(synchronously)
    end   
    end

	assign rv1 = ((reset == 1) ? 0	:	mem[rs1]);
	assign rv2 = ((reset == 1) ? 0	:	mem[rs2]);		
	   
endmodule
