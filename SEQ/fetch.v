module fetch(
    input clk,                 
    input [9:0] pc,         
    output reg [63:0] valC,        
    output reg [63:0] valP,         
    output reg [3:0] rA,           
    output reg [3:0] rB,           
    output reg [3:0] icode,       
    output reg [3:0] ifun,     
    output reg imem_error,        
    output reg mem_error, 
    output reg instr_valid   
);

reg [7:0]  memory[0:1023]; // 1 KB
reg [0:79] instruction; 

reg needvalc;

integer i;

initial begin
    $readmemh("instructions_1.txt", memory);
    $display("%h",memory[0]);
end

always @(*)
begin
    imem_error = 0;
    if(pc > 1023 || pc < 0)
    begin
        imem_error = 1;
    end 

    instruction = {
    memory[pc],
    memory[pc+1],
    memory[pc+2],
    memory[pc+3],
    memory[pc+4],
    memory[pc+5],
    memory[pc+6],
    memory[pc+7],
    memory[pc+8],
    memory[pc+9]
  };
  

    
    
    icode = instruction[0:3];    // Correct if icode is the most significant 4 bits
    ifun = instruction [4:7];    // Correct if ifun follows icode

    

    //needvalc 
    needvalc = 0;

    if (icode == 3 || 4 || 5 || 7 || 8)
    begin
        needvalc = 1;
    end

    //instr_valid
    instr_valid = 0;  
    mem_error = 0;  
    if (icode == 4'b0000 || icode == 4'b0001 || icode == 4'b0010 || icode == 4'b0011 || 
    icode == 4'b0100 || icode == 4'b0101 || icode == 4'b0110 || icode == 4'b0111 || 
    icode == 4'b1000 || icode == 4'b1001 || icode == 4'b1010 || icode == 4'b1011)
    begin

        if(icode == 2 || icode == 7)
        begin
            if(ifun > 6)
            instr_valid = 1;
        end

        else if((icode == 6) && (ifun > 4))
        begin
            instr_valid = 1;
        end

        else
        instr_valid = 0;    
    end

    if((icode == 0) || (icode == 1) || (icode == 9)) 
    begin
        valP = pc + 64'd1; 
        if (icode == 0)
        begin
           mem_error = 1;
        end
    end
    
    else if((icode == 2) || (icode == 6) || (icode == 4'b1010) || (icode == 4'b1011))
    begin
        rA = instruction[8:11];
        rB = instruction[12:15];
        valP = pc + 64'd2;
    end

    else if((icode == 3) || (icode == 4) || (icode == 5))
    begin
        rA = instruction[8:11];
        rB = instruction[12:15];
        valC = {instruction[72:79],instruction[64:71],instruction[56:63],instruction[48:55],instruction[40:47],instruction[32:39],instruction[24:31],instruction[16:23]};
        valP = pc + 64'd10;
    end

    else if((icode == 7) || (icode == 8))
    begin
        valC = {instruction[64:71],instruction[56:63],instruction[48:55],instruction[40:47],instruction[32:39],instruction[24:31],instruction[16:23],instruction[8:15]};
        valP = pc + 64'd9;
    end
end
endmodule