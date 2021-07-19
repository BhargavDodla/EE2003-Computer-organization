module decoder(
    input [31:0] instr,  // Full 32-b instruction
    output [5:0] op,     // some operation encoding of your choice
    output [4:0] rs1,    // First operand
    output [4:0] rs2,    // Second operand
    output [4:0] rd,     // Output reg
    input  [31:0] r_rv2, // From RegFile
    output [31:0] rv2,   // To ALU
    output we,           // Write to reg
    output [19:0] offset   //can be used by load/store for address or by branching/jump for calculating the jump amount
);

//This module is used for decoding the instruction and extracting various required components(address,opcode,offset etc.)   
    
	reg[5:0] op;
	reg[31:0] rv2;
	reg[4:0] rs1;
	reg[4:0] rs2;
	reg[4:0] rd;
	reg we;                 // For writing to regfile set to 1
	reg [19:0] offset;
	reg [31:0] daddr;


	always@(*)
	
	begin
	if (instr == 0)            
		begin
		op = 6'h1f;         //assigning an unused opcode when no instruction is read
		we = 0;
		end
		
    else if (instr[6:0] == 7'b1100011)    //if passed we enter the conditional branching section
	
	begin
        op = {3'b110, instr[14:12]};      //assinging an opcode that is unused by alu and load/store
        offset = {instr[31], instr[7], instr[30:25], instr[11:8]};    //immediate value to determine the jump amount
		we = 0;    //no writing to regfile needed
	end
	
    else if (instr[6:0] == 7'b1100111)     //JALR (trested differently as the immediate value is not in a common place)
	begin
		op = instr[6:1]; 
		offset = instr[31:20];
		we = 1;        //set high to store the link reg
	end
	
    else if (instr[6:0] == 7'b1101111)    //JAL (trested differently as the immediate value is not in a common place)
	begin
		op = 6'b111111;
		offset = {instr[31], instr[19:12], instr[20], instr[30:21]};
		we = 1;        //set high to store the link reg
	end
	
    else if ((instr[6:0] == 7'b0010111) || (instr[6:0] == 7'b0110111))    //LUI and AUIPC
    begin        //(trested differently as the immediate value is not in a common place but these two have it in common)       
		op = {instr[2:0],instr[5:3]};
		offset = instr[31:12];
		we = 1;         //set high as the upper 20 bits must be stores in address rd in regfile 
	end	

    else if (instr[4] == 1)   //If passed we enter the ALU instruction section of the ISA
        
	begin	
        if (instr[5] == 1)	     //If passed we enter the non-immediate ALU instructions
		begin
            op = {instr[5], instr[31:30], instr[14:12]};    //Unique opcode formed by concatenating parts of the instruction
			rv2 = r_rv2;       //getting the value of second operand from the regfile
		end
		
        else if ((instr[5] == 0) && ((instr[14:12] == 3'b001) || (instr[14:12] == 3'b101)))   //SLLI,SRLI and SRAI insrtuctions(treated differently as the immediate value extraction is different from the other immediate instructions)
		begin
			op = {instr[5], instr[31:30], instr[14:12]};     
            rv2 = instr[24:20];        //getting the immediate value for the second operand from the instruction(5 bit)
		end
		
		else    //The immediate section of ALU instructions
            
		begin
            op = {instr[5], 2'b00, instr[14:12]};         
			rv2 = instr[31:20];        //getting the immediate value for the second operand from the instruction(12 bit)
		end
		
    we = 1;                // set to 1 since alu writes to regfile

	end   
	
    else if ((instr[4] == 0) && (instr[6] == 0))      //If passed we enter the load and store section of the ISA
        
	begin
        if (instr[5] == 1)     //If passed we enter the store instruction section
            
		begin
            op = {2'b01, 1'b1, instr[14:12]};    //Forming an unique opcode that do not clash with the alu opcodes
            offset = {instr[31:25], instr[11:7]};  //extracting offset from the instuction for address calculation
			we = 0;			 //Set to 0 as there is no writing to regefile
		end
		
		else     //The load instuctions section
            
		begin		
            op = {2'b01, 1'b0, instr[14:12]};  
            offset = instr[31:20];        
			we = 1;			//Set to 1 as we need to write the loaded value into the regfile
		end	
		
	end 
	
	else
        
		begin 
		op = 6'h1f;          //assigning an unused opcode when no instruction is read
		we = 0;
		end
	

	rs1 = instr[19:15];    //getting address for first operand
    rs2 = instr[24:20];    //getting address for second operand
    rd = instr[11:7];      //getting address for output storage
    
	end

endmodule
