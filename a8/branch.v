module branching(
	input clk,
	input reset,
    input [5:0] op,   //unique opcodes for each instruction,not clashing with alu or load/store
    input [19:0] offset,   //offset for new address calculation 
    input [31:0] rv1,   //operand 1
    input [31:0] rv2,   //operand 2
    output [31:0] iaddr,  //Program counter
    output [31:0] link_reg   //link register or upper immediate
);
    
//This module takes care of condition branching,and jump instuctions
//There are two identical case statements as calculating the new address must be synchronous but generating the link register or storing the upper bits must be aynchronus(as we already have synchronous write to regfile)
	
	reg [31:0] iaddr;
	reg [31:0] link_reg;

    always @(posedge clk)        
    begin
        if (reset) 
        begin
            iaddr = 0;      //Makes sure were start from the 0th insrtuction
        end
        else

     //The new address is calculated by adding the sign extented immediate/offset and adding to previous address       
            
            case (op)     // new address calculation (must be synchronous)
            
      //Jumps to the calculated address if the equality is true else moves to the adjacent instruction
        	6'h30 	:	iaddr = ((rv1 == rv2) ? (iaddr + {{19{offset[11]}},offset[11:0],1'b0}) : (iaddr + 4));    				 
            
      //Jumps to the calculated address if they are not equal else moves to the adjacent instruction
        	6'h31	:	iaddr = ((rv1 != rv2) ? (iaddr + {{19{offset[11]}},offset[11:0],1'b0}) : (iaddr + 4));        				
      //Cheking the inequality by assuming the operands to be signed,jumps to calculated address if true      
        	6'h34	:	iaddr = (($signed(rv1) < $signed(rv2)) ? (iaddr + {{19{offset[11]}},offset[11:0],1'b0}) : (iaddr + 4));
        				
      //Cheking the inequality by assuming the operands to be signed,jumps to calculated address if true
        	6'h35	:	iaddr = (($signed(rv1) >= $signed(rv2)) ? (iaddr + {{19{offset[11]}},offset[11:0],1'b0}) : (iaddr + 4));
       
      //Cheking the inequality by assuming the operands to be unsigned,jumps to calculated address if true
        	6'h36	:	iaddr = ((rv1 < rv2) ? (iaddr + {{19{offset[11]}},offset[11:0],1'b0}) : (iaddr + 4));
        				
      //Cheking the inequality by assuming the operands to be unsigned,jumps to calculated address if true
        	6'h37	:	iaddr = ((rv1 >= rv2) ? (iaddr + {{19{offset[11]}},offset[11:0],1'b0}) : (iaddr + 4));
        	
      //Unconditional jump to the calculated address(relative jump)
            6'h3f	: 	iaddr = iaddr + {{11{offset[19]}},offset[19:0],1'b0};  

      //Unconditional jump to the calculated address(absolute jump)
        	6'h33	:	iaddr = (({{20{offset[11]}},offset[11:0]} + rv1) & 32'hfffffffe);      				
        	
        	6'h3e	:	iaddr = iaddr + 4;     //Moves to the adjacent instuction
        			
        	6'h3a	:	iaddr = iaddr + 4;     //Moves to the adjacent instuction
        	
        	default	:	iaddr = iaddr + 4;     // For non branching/jump instuctions we just move to the next instruction
        
        endcase        
    end
   
    always @(*) 
    begin
        if (reset) 
        begin
            link_reg = 0;
        end
        else

        case (op)            // link register and loading upper immediates (must be combinational)
        	
            6'h30 	:	link_reg = 0;  //implemts BEQ (no linking required)
        	
            6'h31	:	link_reg = 0;  //implemnts BNE (no linking required)
        	
        	6'h34	:	link_reg = 0;  //implemnts BLT (no linking required)
        				
        	6'h35	:	link_reg = 0;  //implemnts BGE (no linking required)
        				
        	6'h36	:	link_reg = 0;  //implemnts BLTU (no linking required)
        				
        	6'h37	:	link_reg = 0;  //implemnts BGEU (no linking required)
        	
            6'h3f	: 	link_reg = iaddr + 4;  //implemnts JAL (link register stored into rd location in regfile)
        				
            6'h33	:	link_reg = iaddr + 4;  //implemnts JALR  (link register stored into rd location in regfile)
        	
            6'h3e	:	link_reg = (offset << 12);   //implements LUI  (loads the upper 20 bits into rd location in regfile)
        				
            6'h3a	:	link_reg = iaddr + (offset << 12);  //implemnts AUIPC 
            //(loading the upper 20 bits added to current address)

            default	:	link_reg = 0;  //no linking required for non jump instructions
        
        endcase        
    end
      
endmodule
