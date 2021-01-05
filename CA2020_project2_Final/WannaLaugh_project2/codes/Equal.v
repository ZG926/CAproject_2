module Equal(
	data1_i,
	data2_i,
	equal_o
);

input   [31:0]      data1_i, data2_i;
output  equal_o;

assign  equal_o = (data1_i == data2_i) ? 1'b1 : 1'b0;

endmodule
