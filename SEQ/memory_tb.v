`timescale 1ns / 1ps

module memory_tb;

reg clk;
reg [3:0] icode;      
reg [63:0] valA;        
reg [63:0] valB;
reg [63:0] valE;          
reg [63:0] valP;
wire [63:0] valM;

memory uut (
    .clk(clk),
    .icode(icode),      
    .valA(valA),        
    .valB(valB),
    .valE(valE),          
    .valP(valP),
    .valM(valM)    
);

initial begin
    clk = 0;
    forever #5 clk = ~clk; 
end

initial begin
    icode = 0;      
    valA = 0;        
    valB = 0;
    valE = 0;          
    valP = 0;

    #100;
    
    icode = 4'b0100; valA = 4; valE = 64'd1; 
    #10;
    $display("Test 1: rmmovq, Writing %d to address %d", valA, valE);

    icode = 4'b0101; 
    #10;
    $display("Test 2: mrmovq, Reading from address %d, valM = %d", valE, valM);

    icode = 4'b1010; valA = 8; valE = 64'd2; 
    #10;
    $display("Test 3: pushq, Writing %d to address %d", valA, valE);

    icode = 4'b1000; valP = 64'd20; valE = 64'd3; 
    #10;
    $display("Test 4: call, Writing return address %d to address %d", valP, valE);

    icode = 4'b1011; valB = 64'd2; 
    #10;
    $display("Test 5: popq, Reading from address %d, valM = %d", valB, valM);
    
    icode = 4'b1001; valB = 64'd3; 
    #10;
    $display("Test 6: ret, Reading return address from %d, valM = %d", valB, valM);
    
    $finish;
end

endmodule
