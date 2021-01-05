module Forwarding_Unit(
	EX_Rs1_i,
	EX_Rs2_i,
	MEM_RegWrite_i,
	MEM_Rd_i,
	WB_RegWrite_i,
	WB_Rd_i,
	Forward_A_o,
	Forward_B_o
);
input [4:0] EX_Rs1_i;
input [4:0] EX_Rs2_i;
input 		MEM_RegWrite_i;
input [4:0] MEM_Rd_i;
input 		WB_RegWrite_i;
input [4:0] WB_Rd_i;
output [1:0] Forward_A_o;
output [1:0] Forward_B_o;
reg 		flag_A;
reg 		flag_B;

reg [1:0] Forward_A_result;
reg [1:0] Forward_B_result;
assign Forward_A_o = Forward_A_result;
assign Forward_B_o = Forward_B_result;

always @(EX_Rs1_i or EX_Rs2_i or MEM_RegWrite_i or MEM_Rd_i or WB_Rd_i or WB_RegWrite_i) begin
	Forward_A_result = 2'b00;
	Forward_B_result = 2'b00;
	flag_A = 1'b0;
	flag_B = 1'b0;
	// EX hazard, instruction distance = 1
	if(MEM_RegWrite_i && (MEM_Rd_i != 0) && (EX_Rs1_i == MEM_Rd_i)) begin
		Forward_A_result = 2'b10;
		flag_A = 1'b1;
	end	

	if(MEM_RegWrite_i && (MEM_Rd_i != 0) && (EX_Rs2_i == MEM_Rd_i)) begin
		Forward_B_result = 2'b10;
		flag_B = 1'b1;
	end	

	// MEM hazard, instruction distance = 2
	if(WB_RegWrite_i && (WB_Rd_i != 0) && (flag_A == 0) && (EX_Rs1_i == WB_Rd_i)) begin
		Forward_A_result = 2'b01;
	end

	if(WB_RegWrite_i && (WB_Rd_i != 0) && (flag_B == 0) && (EX_Rs2_i == WB_Rd_i)) begin
		Forward_B_result = 2'b01;
	end
end

endmodule