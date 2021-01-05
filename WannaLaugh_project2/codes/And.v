module And(
	data1_i,
	data2_i,
	data_o
);

// Ports
input 	data1_i, data2_i;	

output data_o;

assign data_o = data1_i & data2_i;

endmodule
