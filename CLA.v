module multi_cla #(parameter n = 4)(
    input [n-1:0] A,   // Input A
    input [n-1:0] B,  
    output [2*n-1:0] P // product 	
);

    wire [n-1:0] pp [n-1:0];  // Partial products
    wire [2*n-1:0] sum [n:0];  //  sums
    wire [n-1:0] carry;        //  bits

    
    genvar i, j;
    generate
        for (i = 0; i < n; i = i + 1) begin : gen_partial_products
            for (j = 0; j < n; j = j + 1) begin
                assign pp[i][j] = A[i] & B[j]; // Multiple each bit of A with each one in B
            end
        end
    endgenerate

     // Start with zeros and then add the first row of products
    assign sum[0] = { {(n){1'b0}}, pp[0] }; 

    // Add partial product
    generate
        for (i = 1; i < n; i = i + 1) begin : add_partial_products
            wire [n:0] cla_sum; 
            wire cla_cout;      
			
            // Add current partial product to the previous sum
            CarryLookAheadFullAdder #(n) cla (
               .Cin(1'b0),                   // Cin is always 0 for pp add
               .A(sum[i-1][i+n-1:i]),       // Select the bits from sum
               .B(pp[i]),                   
               .S(cla_sum[n-1:0]),          // Sum output
               .Cout(cla_cout)              // Carry out
            );

            // Combine with previous sums
            assign sum[i] = {cla_cout, cla_sum[n-1:0], sum[i-1][i-1:0]};
        end
    endgenerate
	
    assign P = sum[n-1];
endmodule

module CarryLookAheadFullAdder #(parameter WIDTH = 4) (
    input Cin,                     // Carry in
    input [WIDTH-1:0] A,          
    input [WIDTH-1:0] B,          
    output [WIDTH-1:0] S,         // Sum output
    output Cout                    // Carry out
);
    wire [WIDTH-1:0] G, P;        // Generate and propagate 
    wire [WIDTH:0] C;             // Carry array

    // Generate and propagate
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : gen_propagate
            and #5(G[i], A[i], B[i]);   // Generate 																	 /sg
            xor #9(P[i], A[i], B[i]);   // Propagate 
        end
    endgenerate
    
    // Initial carry
    assign C[0] = Cin;
    
    // Calc carry
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : gen_carries
            and #(5) and_gate (C[i], G[i], P[i], C[i]); // Calculate carry for this bit
            or #(5) or_gate (C[i+1], G[i], C[i]);      // Propagate carry to next bit
        end			
    endgenerate

    // Calculate sum
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : gen_sum
            xor #9(S[i], P[i], C[i]);   // Calculate sum
        end
    endgenerate

    // Carry out
    assign Cout = C[WIDTH];   // Assign carry out
endmodule