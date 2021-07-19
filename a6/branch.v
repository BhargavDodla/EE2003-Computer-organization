module branching(
	input clk,
	input reset,
	input [5:0] op,
	input [19:0] offset,
	input [31:0] rv1,
	input [31:0] rv2,
	output [31:0] iaddr,
	output [31:0] link_reg
);
	
	reg [31:0] iaddr;
	reg [31:0] link_reg;

    always @(posedge clk)        
    begin
        if (reset) 
        begin
            iaddr = 0;     // at reset
        end
        else

        case (op)     // new address calclated with offset (must be synchronous)
        	
        	6'h30 	:	iaddr = ((rv1 == rv2) ? (iaddr + {{19{offset[11]}},offset[11:0],1'b0}) : (iaddr + 4));        				      			  	
        	
        	6'h31	:	iaddr = ((rv1 != rv2) ? (iaddr + {{19{offset[11]}},offset[11:0],1'b0}) : (iaddr + 4));        				
     
        	6'h34	:	iaddr = (($signed(rv1) < $signed(rv2)) ? (iaddr + {{19{offset[11]}},offset[11:0],1'b0}) : (iaddr + 4));
        				
        	6'h35	:	iaddr = (($signed(rv1) >= $signed(rv2)) ? (iaddr + {{19{offset[11]}},offset[11:0],1'b0}) : (iaddr + 4));
        				
        	6'h36	:	iaddr = ((rv1 < rv2) ? (iaddr + {{19{offset[11]}},offset[11:0],1'b0}) : (iaddr + 4));
        				
        	6'h37	:	iaddr = ((rv1 >= rv2) ? (iaddr + {{19{offset[11]}},offset[11:0],1'b0}) : (iaddr + 4));
        	
        	6'h3f	: 	iaddr = iaddr + {{11{offset[19]}},offset[19:0],1'b0};
        				
        	6'h33	:	iaddr = (({{20{offset[11]}},offset[11:0]} + rv1) & 32'hfffffffe);      				
        	
        	6'h3e	:	iaddr = iaddr + 4;        				
        			
        	6'h3a	:	iaddr = iaddr + 4;
        	
        	default	:	iaddr = iaddr + 4;
        
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
        	
        	6'h30 	:	link_reg = 0;
        	
        	6'h31	:	link_reg = 0;
        	
        	6'h34	:	link_reg = 0;
        				
        	6'h35	:	link_reg = 0;
        				
        	6'h36	:	link_reg = 0;
        				
        	6'h37	:	link_reg = 0;  
        	
        	6'h3f	: 	link_reg = iaddr + 4;
        				
        	6'h33	:	link_reg = iaddr + 4;
        	
        	6'h3e	:	link_reg = (offset << 12);
        				
        	6'h3a	:	link_reg = iaddr + (offset << 12);
        	
        	default	:	link_reg = 0;
        
        endcase        
    end
      
endmodule
