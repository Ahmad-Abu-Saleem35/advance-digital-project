module tb_multiplier;
    parameter n = 4;
    reg [n-1:0] A, B;
    wire [2*n-1:0] P;

    multi_cla #(n) uut (
        .A(A),
        .B(B),
        .P(P)
    );
    initial begin
        A = 4'b0001; B = 4'b0001; #100; 
        A = 4'b0010; B = 4'b0010; #100; 
        A = 4'b0100; B = 4'b0100; #100; 
        A = 4'b1001; B = 4'b0110; #100; 
		A = 4'b1100; B = 4'b1001; #100; 
        A = 4'b0010; B = 4'b0011; #100; 
		
        $stop;
    end

    initial begin
        $monitor("Time = %0d : A = %b (%0d), B = %b (%0d), P = %b (%0d)", 
                 $time, A, A, B, B, P, P);
    end
endmodule
