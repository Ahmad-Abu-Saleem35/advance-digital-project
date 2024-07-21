module Full_Adder (
    input Cin,
    input A,
    input B,
    output Sum,
    output Cout
);
    wire AxorB, and1, and2;
    xor #9 (AxorB, A, B);  
    xor #9 (Sum, AxorB, Cin); 
    
    and #5 (and1, AxorB, Cin); 
    and #5 (and2, A, B);  
    
    or #5 (Cout, and1, and2);  
endmodule

module RippleCarryAdder4bit(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);
    wire C1, C2, C3;

    Full_Adder fa0 (.Cin(Cin), .A(A[0]), .B(B[0]), .Sum(Sum[0]), .Cout(C1));
    Full_Adder fa1 (.Cin(C1), .A(A[1]), .B(B[1]), .Sum(Sum[1]), .Cout(C2));
    Full_Adder fa2 (.Cin(C2), .A(A[2]), .B(B[2]), .Sum(Sum[2]), .Cout(C3));
    Full_Adder fa3 (.Cin(C3), .A(A[3]), .B(B[3]), .Sum(Sum[3]), .Cout(Cout));
endmodule
   