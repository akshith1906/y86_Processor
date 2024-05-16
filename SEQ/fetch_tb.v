`timescale 1ns / 1ps

module fetch_tb;

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

fetch uut (
    .clk(clk),                 
    .pc(pc),         
    .valC(valC),        
    .valP(valP),         
    .rA(rA),           
    .rB(rB),           
    .icode(icode),       
    .ifun(ifun),     
    .imem_error(imem_error),        
    .mem_error(mem_error) ,
    .instr_valid  
);

initial begin
    clk = 0;
    pc = 0;
    forever #5 clk = ~clk; 
end

initial begin
    #100;
    pc = 0; 
    #10; 

   pc = 10'd1; 
    #10; 

    pc = 10'd3; 
    #10; 
    pc = 10'd5; 
    #10;
    #100;
    $finish; 
end

initial begin
    $monitor("Time: %t | PC: %d | icode: %h | ifun: %h | rA: %h | rB: %h | valC: %d | valP: %d | imem_error: %b | mem_error: %b", 
              $time, pc, icode, ifun, rA, rB, valC, valP, imem_error, mem_error);
end


endmodule
