// D flip-flop code

module d_ff(d, clk, q, q_not);
input d, clk;
output q, q_not;
wire d, clk;
reg q, q_not;

always @(posedge clk) begin
    q <= d;
    q_not <= !d;
end

endmodule