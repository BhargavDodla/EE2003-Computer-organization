// Note: The code below should send a byte to your peripheral.
// You could hardcode the address of your peripheral here, but 
// it is advisable to make it a #define so it is easier to
// change later if needed
#define OUTPERIPH_BASE 0x34560
#define OUTPERIPH_WRITE_OFFSET 0x00
#define OUTPERIPH_READSTATUS_OFFSET 0x04
void _outbyte(int c)
{
	// Fill in the code here
        // What you need is to write to the address of the peripheral (as defined in th BIU)
        // Example code here:
        int *p;  // Pointer to integer
        p = (OUTPERIPH_BASE + OUTPERIPH_WRITE_OFFSET); // Set pointer value directly
        (*p) = c; // Write the value to the address
}

void outbyte(int c)
{
        static char prev = 0;
        if (c < ' ' && c != '\r' && c != '\n' && c != '\t' && c != '\b')
                return;
        if (c == '\n' && prev != '\r') _outbyte('\r');
        _outbyte(c);
        prev = c;
}

// The following function should read back the number of bytes that 
// have gone through the peripheral since system startup.  Again, the
// address of the status readout register is your choice, and can be
// hardcoded here or declared as a #define
int readstatus() 
{
        // Fill in code here
        // Note how the _outbyte function was written, and adapt it to read back the status register
        int *r;  // Pointer to integer
        int d;
        r = (OUTPERIPH_BASE + OUTPERIPH_READSTATUS_OFFSET); // Set pointer value directly
        d = (*r); // Write the value to the address
        return d;
}
