module load_store (
    input reset,
    input [5:0] op,   //unique opcode generated from decoder
    input [31:0] drdata,   //the data loaded from memory
    input [31:0] rv1,    //register loaded from regfile corresponding to address rs1
    input [31:0] rv2,    //register loaded from regfile corresponding to address rs2
    input [11:0] offset,  //offset needed for address calculation
    output [31:0] daddr,  //address for the load/store
    output [31:0] dwdata,   //the data to be stored to memory
    output [3:0] dwe,   //write enable for store
    output [31:0] to_reg_data   //the modified loaded value to be stored in regfile
);

 //This module implemnts the load and store functions of the CPU   
 //Here it is assumed that there are no misalligned load or store   
  
    reg [31:0] daddr;
    reg [31:0] dwdata;
    reg [3:0] dwe;
    reg [31:0] to_reg_data;
    reg [1:0] remainder;   
     
    always@(*)
    begin
        
        if (reset)         //Initializing during reset condition
        begin
            daddr = 0;
            dwdata = 0;
            dwe = 0;
            to_reg_data = 0;
        end
        
        else
        
        begin
        //Calculating the address correseponding where to load from or where to store to(offset is being sign extended)
            daddr = ({{20{offset[11]}},offset[11:0]} + rv1);   
            remainder = daddr[1:0];   //remainder of the address by 4,needed for shifting to appropriate byte/halfword postion 
            to_reg_data = 0;
            dwdata = 0;
            dwe = 0;
         //Conditioned on the unique opcode (which does not clah with ALU opcodes)
            case (op)   
				6'h10	: begin   // implementing LB instruction
         //Shifting by the approprite number of bytes and masking to obtiain only the last byte
                          to_reg_data = ((drdata >> (8*remainder)) & (32'h000000ff));  
                          to_reg_data = {{24{to_reg_data[7]}},to_reg_data[7:0]};   //storing the sign extended byte 
   					      end
   					      
				6'h11	: begin  // implemneting LH instruction
         //Getting the lower or upper halfword
                          to_reg_data = (remainder == 0) ? (drdata & 32'h0000ffff) : ((drdata >> 16) & (32'h0000ffff));         
                          to_reg_data = {{16{to_reg_data[15]}},to_reg_data[15:0]};     //storing the sign extended half word
						  end
						  
				6'h12	: to_reg_data = drdata;        //Implementing LW instruction
				
         //Shifting by the appropriate number of bytes and masking the lower byte        
                6'h14	: to_reg_data = (drdata >> (8*remainder)) & (32'h000000ff);   //implemting LBU instruction
				
         //implemting LHU instruction (getting the lower or upper halfword )
				6'h15	: to_reg_data = (remainder == 0) ? (drdata & 32'h0000ffff) : ((drdata >> 16) & (32'h0000ffff));         

				6'h18	: begin         //implementing SB instruction
                          dwdata = (rv2 << (8*remainder));    //Shifting the data to appropriate byte location 
						  dwe = {(remainder[1]*remainder[0]),(remainder[1]*(~remainder[0])),((~remainder[1])*remainder[0]),((~remainder[1])*(~remainder[0]))};    //Making the corresponding byte's write enable "1" to store that corresponding byte
						  end
						  
				6'h19	: begin          //implemnting the SH instruction
                    dwdata = (remainder == 0) ? (rv2 & 32'h0000ffff) : (rv2 << 16);     //Storing the lower of upper halfowrd
                    dwe = (remainder == 0) ? (4'b0011) : (4'b1100);  //Enabling the corresponding write enable signals
						  end
						  
				6'h1a	: begin        //Implementing SW instruction
						  dwdata = rv2;         
						  dwe = 4'b1111;   
						  end
						  
			default	 : begin
					   dwdata = 0;
			           dwe = 4'b0000;    
			           to_reg_data = 0;
			           end
			endcase	             
 
      end
      
        //In the above cases shifting by "appropriate" implies that for load/store byte:
        //if remainder = 0,we do not shift(for store byte write enable = "0001")
        //if remainder = 1,we shift by one byte(for store byte write enable = "0010")
        //if remainder = 2,we shift by two bytes(for store byte write enable = "0100")
        //if remainder = 3,we shift by three bytes(for store byte write enable = "1000")
        
        
        //In the cases of load/tore halfword:
        //if remainder is 0,we do not shift(for store halfword write enable = "0011")
        //if remiander is 2,we shift by 16 bits(2 bytes)(for store halfword write enable = "1100")
        //(here a remainder or 1 or 3 is a missallignment)

      end
    
endmodule
