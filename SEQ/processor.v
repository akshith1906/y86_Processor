`timescale 1ns / 1ps

module processor();

// Testbench signals
reg clk;                 
reg [9:0] pc;         
wire [63:0] valC;        
wire [63:0] valP;         
wire [3:0] rA;           
wire [3:0] rB;           
wire [3:0] icode;       
wire [3:0] ifun;     
wire imem_error;        
wire mem_error;
wire instr_valid;
wire [63:0]valA;
wire [63:0]valB;
wire [63:0]valE;
wire [63:0]valM;
wire [63:0]dstE;
wire g;
wire ge;
wire e;
wire ne;
wire l;
wire le;
wire [63:0] rax, rcx, rdx, rbx, rsp, rbp, rsi, rdi, r8, r9, r10, r11, r12, r13, r14;
wire [63:0] newPC;
wire [63:0] val_temp;

fetch uut(clk, pc, valC, valP,rA,rB,icode,ifun,imem_error,mem_error,instr_valid);
decoder uut1(clk,rA,rB,icode,ifun,valC,g,ge,e,ne,le,l,valM,valE,valP,valA,valB,rax,rcx,rdx,rbx,rsp,rbp,rsi,rdi, r8, r9, r10, r11, r12, r13, r14);
execute uut2(clk,valA,valB,icode,ifun,valC,valE,g,ge,e,ne,le,l,val_temp);
memory uut3(clk,icode,valA,valB,valE,valP,valM);
pcupdate uut4(icode,ifun,valC,valM,valP,le,l,e,ne,ge,g,newPC);

initial begin
    clk = 0;
    pc = 0;
    forever #5 clk = ~clk;
end
initial begin
    #5;
    #5;
    #5;
    #5;
    #5;
    #5;
    #5;
    #5;
    #5;
    #5;
    #5;
    #5;
    #5;
    #5;
    #5;
    #5;
    #5;
    #5;
    #5;
    #5;
    #5;
    #5;
    #5;
    #5;
    #5;
    #5;
    #5;
    #5;
    #5;
    #5;
    $finish;
end

initial begin
    $dumpfile("processor.vcd");
    $dumpvars(0, processor);
end

    always@(posedge clk) begin
        if (imem_error == 1)
        begin
            $display("Instruction memory error");
        end
        if(mem_error == 1)
        begin
            $display("halt");
            $finish;
        end
        if (instr_valid == 1)
        begin
            $display("Instruction invalid");
        end
    pc = newPC;
    end
 
initial begin
    // Monitor changes and display outputs
    $monitor("Time: %t | PC: %d | icode: %h | ifun: %h | rA: %h | rB: %h | valC: %d | valP: %d |r0 = %d |r1: %d |r2 :%d| valE: %d\n e:%d| val_temp: %d ",$time, pc, icode, ifun, rA, rB, valC, valP, rax, rcx, rdx,valE,e,val_temp);

end
endmodule