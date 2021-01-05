module MUX32_4(
	Forward_i,
	EX_RS_Data_i,
	MEM_ALU_Result_i,
	WB_WriteData_i,
	MUX_Result_o
);
input [1:0] Forward_i;
input [31:0] EX_RS_Data_i;
input [31:0] MEM_ALU_Result_i;
input [31:0] WB_WriteData_i;
output [31:0] MUX_Result_o;

reg [31:0] MUX_Result;
assign MUX_Result_o = MUX_Result;

always @(Forward_i or EX_RS_Data_i or MEM_ALU_Result_i or WB_WriteData_i) begin
	if(Forward_i == 2'b00) begin
		MUX_Result = EX_RS_Data_i;
	end
	else if(Forward_i == 2'b01) begin
		MUX_Result = WB_WriteData_i;
	end
	else if(Forward_i == 2'b10) begin
		MUX_Result = MEM_ALU_Result_i;
	end
end

endmodule