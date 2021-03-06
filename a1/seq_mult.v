//                              -*- Mode: Verilog -*-
// Filename        : seq-mult.v
// Description     : Sequential multiplier
// Author          : Nitin Chandrachoodan

// This implementation corresponds to a sequential multiplier, but
// most of the functionality is missing.  Complete the code so that
// the resulting module implements multiplication of two numbers in
// twos complement format.

// All the comments marked with *** correspond to something you need
// to fill in.

// This style of modeling is 'behavioural', where the desired
// behaviour is described in terms of high level statements ('if'
// statements in verilog).  This is where the real power of the
// language is seen, since such modeling is closest to the way we
// think about the operation.  However, it is also the most difficult
// to translate into hardware, so a good understanding of the
// connection between the program and hardware is important.

`define width 8
`define ctrwidth 4

module seq_mult (
		 // Outputs
		 p, rdy, 
		 // Inputs
		 clk, reset, a, b
		 ) ;
   input 		 clk, reset;
   input [`width-1:0] 	 a, b;
   									// *** Output declaration for 'p'
   output [(`width*2)-1:0]  p;
   output 		 rdy;
   
  									// *** Register declarations for p, multiplier, multiplicand
   reg 			 p;
   reg [(`width*2)-1:0] multiplier,multiplicand;
   reg 			 rdy;
   reg [`ctrwidth:0] 	 ctr;
   
   always @(posedge clk or posedge reset)
     if (reset) begin
	rdy 		<= 0;
	p 		<= 0;
	ctr 		<= 0;
	multiplier 	<= {{`width{a[`width-1]}}, a}; // sign-extend
	multiplicand 	<= {{`width{b[`width-1]}}, b}; // sign-extend
     end else begin
	if (ctr < (`width*2)) //clock has to go 16 times since the multiplier is 16 bits
	  begin            // *** Code for multiplication     
  
	  	p = p + (multiplier[ctr] ? ({{`width{b[`width-1]}}, b} << ctr) : 0); 
	  // Ternary operator is the mux in the circuit which chooses based on the multiplier bit
	  
	  	ctr = ctr + 1;  //incrementing the clock
	  
	  end else begin
	     rdy <= 1; 		// Assert 'rdy' signal to indicate end of multiplication
	  end  
     end   
   
endmodule // seqmult























