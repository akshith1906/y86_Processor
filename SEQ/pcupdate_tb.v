`timescale 1ns / 1ps

module pcupdate_tb;

reg [3:0] icode; 
reg [3:0] ifun;     
reg [63:0] valC;   
reg [63:0] valM;    
reg [63:0] valP;
reg le;
reg l;
reg e;
reg ne;
reg ge;
reg g;
wire [63:0] newPC;

// Instantiate the Unit Under Test (UUT)
pcupdate uut (
    .icode(icode), 
    .ifun(ifun),     
    .valC(valC),   
    .valM(valM),    
    .valP(valP),
    .le(le),
    .l(l),
    .e(e),
    .ne(ne),
    .ge(ge),
    .g(g),
    .newPC(newPC)
);

initial begin
    // Initialize Inputs
    valC = 64'd100;   
    valM = 64'd200;    
    valP = 64'd300;
    le = 0;
    l = 0;
    e = 0;
    ne = 0;
    ge = 0;
    g = 0;

    // CALL instruction simulation
    icode = 4'b1000; // CALL
    #10; // Wait for simulation
    $display("CALL Instruction, newPC should be %d, actual newPC = %d", valC, newPC);
    
    // RET instruction simulation
    icode = 4'b1001; // RET
    #10; // Wait for simulation
    $display("RET Instruction, newPC should be %d, actual newPC = %d", valM, newPC);
    
    // JXX instruction simulation with all flags
    icode = 4'b0111; // JXX

    // Test JXX with ifun for unconditional jump
    ifun = 4'b0000; // JMP
    #10;
    $display("JXX JMP Instruction, newPC should be %d, actual newPC = %d", valC, newPC);

    // Test JXX with ifun and condition flags
    ifun = 4'b0001; le = 0; // JLE
    #10;
    $display("JXX JLE Instruction, newPC should be %d, actual newPC = %d", valC, newPC);
    
    // Add more test cases for other conditions (l, e, ne, ge, g) as needed

    // Reset condition flags for next test
    le = 0;

    // Example: Testing JXX with JG and flag g set
    ifun = 4'b0110; g = 1; // JG
    #10;
    $display("JXX JG Instruction, newPC should be %d, actual newPC = %d", valC, newPC);
    
    // Add additional scenarios here
end

endmodule
