module mux (
    input S0, 
    input S1, 
    output D0, D1, D2, D3
);
    wire S0comp, S1comp;
    
    not n1(S0comp, S0);
    not n2(S1comp, S1);

    and a1(D0, S0comp, S1comp);
    and a2(D1, S0, S1comp);
    and a3(D2, S0comp, S1);
    and a4(D3, S0, S1);
endmodule

module adder (
    input [63:0] A, 
    input [63:0] B, 
    input M, 
    output [63:0] sum
);
    genvar i;
    wire [64:0] C;
    wire [63:0] AXORB, BXORM;
    wire [63:0] AND1, AND2;

    assign C[0] = M;

    generate
        for (i = 0; i <= 63; i = i + 1) 
        begin 
            xor x1(BXORM[i], C[0], B[i]);
            xor x2(AXORB[i], A[i], BXORM[i]);
            xor x3(sum[i], AXORB[i], C[i]);
            and a1(AND1[i], A[i], BXORM[i]);
            and a2(AND2[i], AXORB[i], C[i]);
            or o1(C[i+1], AND1[i], AND2[i]);
        end
    endgenerate
endmodule

module subtractor (
    input [63:0] A, 
    input [63:0] B, 
    input M, 
    output [63:0] diff
);
    genvar i;
    wire [64:0] C;
    wire [63:0] AXORB, BXORM;
    wire [63:0] AND1, AND2;

    assign C[0] = M;

    generate    
        for (i = 0; i <= 63; i = i + 1) 
        begin 
            xor x1(BXORM[i], C[0], B[i]);
            xor x2(AXORB[i], A[i], BXORM[i]);
            xor x3(diff[i], AXORB[i], C[i]);
            and a1(AND1[i], A[i], BXORM[i]);
            and a2(AND2[i], AXORB[i], C[i]);
            or o1(C[i+1], AND1[i], AND2[i]);
        end
    endgenerate
endmodule

module andder (
    input [63:0] A, 
    input [63:0] B, 
    output [63:0] and_out
);
    genvar i;
    generate
        for (i = 0; i <= 63; i = i + 1) 
        begin 
            and a1(and_out[i], A[i], B[i]);
        end
    endgenerate
endmodule

module xor_calc (
    input [63:0] A, 
    input [63:0] B, 
    output [63:0] xor_out
);
    genvar i;
    generate
        for (i = 0; i <= 63; i = i + 1) 
        begin 
            xor x1(xor_out[i], A[i], B[i]);
        end
    endgenerate
endmodule

//Final Implementation
module final (
    input S0, 
    input S1, 
    input [63:0] A, 
    input [63:0] B, 
    output [63:0] sum, 
    output [63:0] diff, 
    output [63:0] and_out, 
    output [63:0] xor_out, 
    output reg overflow
);
    wire D0, D1, D2, D3;
    mux d1(S0, S1, D0, D1, D2, D3);
    wire [63:0] Aadd, Badd, Asub, Bsub, Aand, Band, Axor, Bxor;
    genvar i;
    generate
        for (i = 0; i <= 63; i = i + 1) 
        begin 
            and a1(Aadd[i], A[i], D0);
            and a2(Badd[i], B[i], D0);
            and a3(Asub[i], A[i], D1);
            and a4(Bsub[i], B[i], D1);
            and a5(Aand[i], A[i], D2);
            and a6(Band[i], B[i], D2);
            and a7(Axor[i], A[i], D3);
            and a8(Bxor[i], B[i], D3);
        end
    endgenerate

    adder add1(.A(Aadd), .B(Badd), .M(D1), .sum(sum));
    subtractor sub1(.A(Asub), .B(Bsub), .M(D1), .diff(diff));
    andder and1(.A(Aand), .B(Band), .and_out(and_out));  
    xor_calc xor1(.A(Axor), .B(Bxor), .xor_out(xor_out));

    always @* begin 
        if ((S0 == 0) && (S1 == 0)) begin
            if (((Aadd > 0) && (Badd > 0) && (sum < 0)) || ((sum >= 0) && (Aadd < 0) && (Badd < 0))) begin
                overflow = 1;
            end
            else begin
                overflow = 0;
            end
        end
        else begin
            overflow = 0;
        end
    end

    always @* begin
        if ((S0 == 1) && (S1 == 0)) begin
            if (((Asub > 0) && (Bsub < 0) && (diff < 0)) || ((diff > 0) && (Asub < 0) && (Bsub > 0))) begin
                overflow = 1;
            end
            else begin
                overflow = 0;
            end
        end
        else begin
            overflow = 0;
        end
    end
endmodule

module execute (
    input clk,
    input [63:0] valA,
    input [63:0] valB,
    input [3:0] icode,
    input [3:0] ifun,
    input [63:0] valC,
    output reg [63:0] valE,
    output reg g,
    output reg ge,
    output reg e,
    output reg ne,
    output reg le,
    output reg l,
    output reg [63:0] val_temp
);

    wire [63:0] sum, diff, and_out, xor_out;
    wire overflow;

    wire [63:0] sum1, diff1, and_out1, xor_out1;
    wire overflow1;

    wire [63:0] sum2, diff2, and_out2, xor_out2;
    wire overflow2;

    wire [63:0] sum3, diff3, and_out3, xor_out3;
    wire overflow3;

    wire [63:0] sum4, diff4, and_out4, xor_out4;
    wire overflow4;

    reg overflowflag;
    
    reg ZF,SF,OF;
    
    initial begin
        ZF = 0;
        SF = 0;
        OF = 0;
    end

    final final_module(1'b0, 1'b0, valA, valB, sum, diff, and_out, xor_out, overflow);

    final final_module2(1'b0, 1'b0, valC, valB, sum1, diff1, and_out1, xor_out1, overflow1);

    final final_module3(1'b1, 1'b1,valA, valB, sum2,diff2, and_out2, xor_out2, overflow2);

    final final_module4(1'b1, 1'b0, valA, valB, sum3, diff3, and_out3, xor_out3, overflow3);

    final final_module5(1'b0, 1'b1, valA, valB, sum4, diff4, and_out4, xor_out4, overflow4);


    always @* begin
            case(icode)
                4'b0100, 4'b0101: begin // rmmovq and mrmovq
                    valE = sum1;
                    //is it valC or (valA + valB) or (valA + valC)
                end
                4'b0100: begin // push
                    valE = valB - 64'd8; //changed from valA 
                end
                4'b0101: begin // pop
                    valE = valB + 64'd8;
                end
                8: begin // call
                    valE = valB + 64'd8;
                end
                9: begin // ret
                    valE = valB - 64'd8;
                end
                3: begin // irmovq
                    valE = valA;
                end
                2: begin // rrmovq
                    valE = valA;
                end
                6: begin // Add, Subtract, And, Xor
                    case(ifun)
                        0: begin // Add
                            valE = sum;
                            val_temp = valE;
                            overflowflag = overflow;
                        end
                        1: begin // Subtract
                            valE = diff3;
                            val_temp = valE;
                            overflowflag = overflow3;
                        end
                        2: begin // And
                            valE = and_out4;
                            val_temp = valE;
                            overflowflag = overflow4;
                        end
                        3: begin // Xor
                            valE = xor_out2;
                            val_temp = valE;
                            overflowflag = overflow2;
                        end
                    endcase
                end
            endcase

        if(val_temp == 0)
        begin
            ZF = 1;
        end

        if(val_temp < 0)
        begin
            SF = 1;
        end

        if(val_temp > 0)
        begin
            ZF = 0;
            SF = 0;
        end

        if(overflowflag == 1)
        begin
            OF = 1;
        end
        
        g = ~(SF ^ OF) && (~ZF);
        ge = ~(SF ^ OF);
        e = ZF;
        ne = ~ZF;
        le = (SF ^ OF) || ZF;
        l = SF ^ OF;
    end
endmodule
