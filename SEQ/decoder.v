module decoder(
    input clk,                 
    input [3:0] rA,           
    input [3:0] rB,           
    input [3:0] icode,       
    input [3:0] ifun,     
    input [63:0] valC,
    input g,
    input ge,
    input e,
    input ne,
    input le, 
    input l,        
    input [63:0] valM,
    input [63:0] valE,
    input [63:0] valP,
    output reg [63:0] valA,
    output reg [63:0] valB,
    output reg [63:0] rax, rcx, rdx, rbx, rsp, rbp, rsi, rdi, r8, r9, r10, r11, r12, r13, r14
);

    reg [63:0] registers [0:14];
        integer i;
        initial begin
            for(i = 0; i <= 14; i=i+1) begin
                registers[i] = 0;
            end
        end 

    reg stack_pointer;
    reg [63:0] destE, destM;


    always @(*)
    begin

        rax = registers[0];
        rcx = registers[1];
        rdx = registers[2];
        rbx = registers[3];
        rsp = registers[4];
        rbp = registers[5];
        rsi = registers[6];
        rdi = registers[7];
        r8  = registers[8];
        r9  = registers[9];
        r10 = registers[10];
        r11 = registers[11];
        r12 = registers[12];
        r13 = registers[13];
        r14 = registers[14];
        
        //halt and nop - do nothing.
        if (icode == 4'b0010)
        begin
            //cmovXX
            valA = registers[rA];
        end

        if (icode == 4'b0011)
        begin
            //irmovq
            valA = registers[rB];
        end

        if (icode == 4'b0100)
        begin
            //rmmovq
            valA = registers[rA];
            valB = registers[rB];
        end

        if (icode == 4'b0101)
        begin
            //mrmovq
            valB = registers[rB];
        end 

        if (icode == 4'b0110)
        begin
            //OPq
            valA = registers[rA];
            valB = registers[rB];
        end

        if (icode == 4'b1000)
        begin
            //call
            stack_pointer = 4;
            // valA = registers[stack_pointer];   
            valB = registers[stack_pointer];   
        end

        if (icode == 4'b1001)
        begin
            //ret
            stack_pointer = 4;
            // valA = registers[stack_pointer];   
            valB = registers[stack_pointer];
        end

        if (icode == 4'b1010)
        begin
            //pushq
            stack_pointer = 4;
            valA = registers[rA];
            valB = registers[stack_pointer];
        end

        if (icode == 4'b1011)
        begin
            //popq
            stack_pointer = 4;
            valB = registers[stack_pointer];
        end
    end

    //Writeback
    always @(posedge clk)
    begin
        if (icode == 4'b0010)
        begin
            //rrmovq
            if(ifun == 4'b0000)
            begin
                destE = rB;
                registers[destE] = valE;
            end

            //cmovle
            if((ifun == 4'b0001) && (le == 1))
            begin
                destE = rB;
                registers[destE] = valE;
            end

            //cmovl
            if((ifun == 4'b0010) && (l == 1))
            begin
                destE = rB;
                registers[destE] = valE;
            end

            //cmove
            if((ifun == 4'b0011) && (e == 1))
            begin
                destE = rB;
                registers[destE] = valE;
            end

            //cmovne
            if((ifun == 4'b0100) && (ne == 1))
            begin
                destE = rB;
                registers[destE] = valE;
            end

            //cmovge
            if((ifun == 4'b0101) && (ge == 1))
            begin
                destE = rB;
                registers[destE] = valE;
            end

            //cmovg
            if((ifun == 4'b0110) && (g == 1))
            begin
                destE = rB;
                registers[destE] = valE;
            end
        end

        //irmovq
        if (icode == 4'b0011)
        begin
            registers[rB] = valC;
        end

        //rmmovq - nothing

        //mrmovq
        if (icode == 4'b0101)
        begin
            registers[rA] = valM; // we changed it to rA from rB
        end 

        //OPq
        if (icode == 4'b0110)
        begin
            registers[rB] = valE;
        end

        //call
        if (icode == 4'b1000)
        begin
            stack_pointer = 4;
            registers[stack_pointer] = valP;   
        end

        //ret
        if (icode == 4'b1001)
        begin
            stack_pointer = 4;
            registers[stack_pointer] = valP;
        end

        //pushq
        if (icode == 4'b1010)
        begin
            stack_pointer = 4;
            registers[stack_pointer] = valE;
        end

        //popq
        if (icode == 4'b1011)
        begin
            stack_pointer = 4;
            registers[stack_pointer] = valE;
        end
    end
endmodule