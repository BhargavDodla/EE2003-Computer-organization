module load_store (
    input reset,
    input [5:0] op,
    input [31:0] drdata,
    input [31:0] rv1,
    input [31:0] rv2,
    input [11:0] offset,
    output [31:0] daddr,
    output [31:0] dwdata,
    output [3:0] dwe,
    output [31:0] to_reg_data
);

    reg [31:0] daddr;
    reg [31:0] dwdata;
    reg [3:0] dwe;
    reg [31:0] to_reg_data;
    reg [1:0] remainder;   
     
    always@(*)
    begin
        
        if (reset)      // reset condition
        begin
            daddr = 0;
            dwdata = 0;
            dwe = 0;
            to_reg_data = 0;
        end
        
        else
        
        begin
         
        	daddr = ({{20{offset[11]}},offset[11:0]} + rv1);         // read/write address calculation
        	remainder = daddr[1:0];
            
        	case (op)          // various types of loads and stores based on opcode
        	
				6'h10	: begin
						  to_reg_data = ((drdata >> (8*remainder)) & (32'h000000ff));
						  to_reg_data = {{24{to_reg_data[7]}},to_reg_data[7:0]};
						  dwe = 0;
   					      end
   					      
				6'h11	: begin
						  to_reg_data = (remainder == 0) ? (drdata & 32'h0000ffff) : ((drdata >> 16) & (32'h0000ffff));
						  to_reg_data = {{16{to_reg_data[15]}},to_reg_data[15:0]};
						  dwe = 0;
						  end
						  
				6'h12	: begin
						  to_reg_data = drdata;
						  dwe = 0;
						  end
				
				6'h14	: begin
						  to_reg_data = (drdata >> (8*remainder)) & (32'h000000ff);
						  dwe = 0;
						  end
				
				
				6'h15	: begin
						  to_reg_data = (remainder == 0) ? (drdata & 32'h0000ffff) : ((drdata >> 16) & (32'h0000ffff));
						  dwe = 0;
						  end

				6'h18	: begin
						  dwdata = (rv2 << (8*remainder));
						  dwe = {(remainder[1]*remainder[0]),(remainder[1]*(~remainder[0])),((~remainder[1])*remainder[0]),((~remainder[1])*(~remainder[0]))};
						  end
						  
				6'h19	: begin
						  dwdata = (remainder == 0) ? (rv2 & 32'h0000ffff) : (rv2 << 16);
						  dwe = (remainder == 0) ? (4'b0011) : (4'b1100);
						  end
						  
				6'h1a	: begin 
						  dwdata = rv2;
						  dwe = 4'b1111;
						  end
						  
			default	 : begin
					   daddr = 0;
					   dwdata = 0;
			           dwe = 4'b0000;
			           to_reg_data = 0;
			           end
			endcase	             
 
      end
      
      end
    
endmodule
