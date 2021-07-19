.global fib
fib:

# Return result in reg a0
 
    	li a1, 1    # First number in the Fibonacci series
    	li a2, 1	# Second number in the Fibonacci series
    	li a4, 2
    	bge a4, a0, jump1    # check if the number provided is less than or equal to 2 and jump

jump2:  addi a0, a0, -1      # Counting backwards by reducing one
    	add a3, a2, a1       # Fibonacci rule
    	mv a1, a2            # Storing the present output as previous value
    	mv a2, a3		     # Storing the present value as previous value
    	bne a0, a4, jump2    # Continue loop until we hit 2
    	mv a0, a3            # Store the final value in a0
    	bge a0, a4, jump3    # Jump to return statement
    
jump1:  mv a0, a1   # Store 1 if given number is less than or qual to 2
jump3:  jr ra       # Return address was stored by original call
