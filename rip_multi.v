module rip_multi #(parameter n = 4)(
    input [n-1:0] A,
    input [n-1:0] B,
    output [2*n-1:0] P
);
    wire [n-1:0] pp [n-1:0];
    wire [n:0] sum [n-1:0]; 
    wire [n-1:0] carry;

    // Generate partial product
    genvar i, j;
    generate
        for (i = 0; i < n; i = i + 1) begin : gen_partial_products
            assign pp[i] = A & {n{B[i]}};
        end

        // Sum the partial products use ripple adders
        for (i = 0; i < n-1; i = i + 1) begin : gen_rca
            if (i == 0) begin
                RippleCarryAdder4bit rca (
                    .A(pp[1]),
                    .B({1'b0, pp[0][n-1:1]}),
                    .Cin(1'b0),
                    .Sum(sum[i][n-1:0]),
                    .Cout(sum[i][n])
                );
            end else begin
                RippleCarryAdder4bit rca (
                    .A(pp[i+1]),
                    .B({carry[i-1], sum[i-1][n-1:1]}),
                    .Cin(1'b0),
                    .Sum(sum[i][n-1:0]),
                    .Cout(sum[i][n])
                );
            end
            assign carry[i] = sum[i][n];
        end
    endgenerate

    // Assign final product b
    assign P[0] = pp[0][0];
    assign P[1] = sum[0][0];
    assign P[2] = sum[1][0];
    assign P[3] = sum[2][0];
    assign P[4] = sum[2][1];
    assign P[5] = sum[2][2];
    assign P[6] = sum[2][3];
    assign P[7] = sum[2][4];

endmodule

module tb_multip;

    reg [3:0] A, B;
    wire [7:0] P;

    rip_multi uut (
        .A(A),
        .B(B),
        .P(P)
    );

    initial begin
		 $monitor("Time = %0d : A = %b (%0d), B = %b (%0d), P = %b (%0d)", 
                 $time, A, A, B, B, P, P);

        #100 A = 4'b0001; B = 4'b0001;  //  P = b0000_0001
        #100 A = 4'b0010; B = 4'b0010;  //  P =b0000_0100
        #100 A = 4'b0100; B = 4'b0100;  //  P = b0001_0000
        #100 A = 4'b1111; B = 4'b1111;  //  P = b1110_0001
        #100 A = 4'b0101; B = 4'b1010;  //  P = b0011_0010

        #800 $finish;
    end
endmodule
