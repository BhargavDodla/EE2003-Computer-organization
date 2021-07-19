`timescale 1ns/1ps
`define OUTFILE "output.txt"

module outperiph (
    input clk,
    input reset,
    input [31:0] daddr,
    input [31:0] dwdata,
    input [3:0] dwe,
    output [31:0] drdata
);

    // Implement the peripheral logic here: use $fwrite to the file output.txt
    // Use the `define above to open the file so that it can be 
    // overridden later if needed

    // Return value from here (if requested based on address) should
    // be the number of values written so far
    reg [31:0] mem;
    integer file;
    integer count = 0;
    initial begin
        if (dwe[0] || dwe[1] || dwe[2] || dwe[3])
             begin
                 file = $fopen("output.txt","w");
                 $fwrite(file,"%s",mem);
             end
    end

    
    // Selecting bytes to be done inside CPU

    always @(posedge clk) begin
        if (dwe[3]) mem[31:24] = dwdata[31:24];
        if (dwe[2]) mem[23:16] = dwdata[23:16];
        if (dwe[1]) mem[15: 8] = dwdata[15: 8];
        if (dwe[0]) mem[ 7: 0] = dwdata[ 7: 0];
        
        if (dwe[0] || dwe[1] || dwe[2] || dwe[3])
            begin
                file = $fopen("output.txt","w");
                $fwrite(file,"%b",dwdata);
                count = count + 1;
                $fclose(file);
            end
    end
    
//     initial begin
//         $monitor("DWDATA   %h",dwe);
//     end
        
    assign drdata = count;  

endmodule