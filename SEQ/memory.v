module memory(
    input clk,
    input [3:0] icode,      
    input [63:0] valA,        
    input [63:0] valB,
    input [63:0] valE,          
    input [63:0] valP,
    output reg [63:0] valM     
);

reg [63:0] memory[0:1023]; 
reg [63:0] address, data;

always@(posedge clk)
    begin
        //rmmovq
        if(icode == 4'b0100) 
        begin
            address = valE;
            memory[address] = valA;
        end

        // pushq 
        else if(icode == 4'b1010)
        begin
            address = valE;
            memory[address]= valA;
        end

        // call
        else if (icode == 4'b1000) 
        begin 
            address = valE;
            memory[address] = valP;
        end
    end

    always@(*)
    begin
        //mrmovq
        if(icode == 4'b0101)
        begin
            address = valE;
            valM = memory[address];
        end

        //popq (We dont know if its valB or valA
        if(icode==4'b1011)
        begin
            address = valB;
            valM = memory[address];
        end

        //ret
         else if (icode == 4'b1001) 
         begin
            address = valB;
            valM = memory[address];
        end
    end
  
endmodule