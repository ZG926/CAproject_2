module Sign_Extend(
    data_i,	
    data_o	  
);

// Ports
input 	[31:0] 		data_i;

output 	[31:0] 		data_o;

reg 	[31:0] 		data_o;

always @ (data_i) begin
		case(data_i[6:0])
		// R-Type (Arithmetic)
		7'b0110011: begin
			data_o[31:0]  = 32'b0;
		end

		// I-Type (Immediate Arithmetic) 
		7'b0010011: begin
			data_o[31:0] = {{20{data_i[31]}},data_i[31:20]};
		end

		// I-Type (Load) 
		7'b0000011: begin
			data_o[31:0] = {{20{data_i[31]}},data_i[31:20]};
		end

		// S-Type (Store)
		7'b0100011: begin
			data_o[31:12] = {20{data_i[31]}};
			data_o[11:5] = data_i[31:25];
			data_o[4:0] = data_i[11:7];
		end

		// SB-Type (Branch)
		7'b1100011: begin
			data_o[31:11] = {21{data_i[31]}};
			data_o[10] = data_i[7];
			data_o[9:4] = data_i[30:25];
			data_o[3:0] = data_i[11:8];
		end

		7'b0000000: begin
			data_o[31:0] = 32'b0;
		end
	endcase	
end

	
endmodule
