module pcupdate(
    input [3:0] icode, 
    input [3:0] ifun,     
    input [63:0] valC,   
    input [63:0] valM,    
    input [63:0] valP,
    input le,
    input l,
    input e,
    input ne,
    input ge,
    input g,
    output reg [63:0] newPC
);

always @(*) begin
    newPC = valP;
    
    if (icode == 4'b1000) 
    begin // call Dest
        newPC = valC; // Set PC to destination
    end 

    else if (icode == 4'b1001) 
    begin // ret
        newPC = valM; // Set PC to return address
    end

    else if(icode == 4'b0111)
    begin
        if(ifun == 4'b0000)
        begin
            newPC = valC;
        end

        else if ((ifun == 4'b0001) && (le == 1))  
        begin
            newPC = valC; 
        end

        else if ((ifun == 4'b0010) && (l == 1)) 
        begin
            newPC = valC;
        end

        else if ((ifun == 4'b0011) && (e == 1)) 
        begin
            newPC = valC;
        end

        else if ((ifun == 4'b0100) && (ne == 1))
        begin
            newPC = valC;
        end

        else if ((ifun == 4'b0101) && (ge == 1))
        begin
            newPC = valC;
        end

        else if ((ifun == 4'b0110) && (g == 1))
        begin
            newPC = valC;
        end
    end
end
endmodule