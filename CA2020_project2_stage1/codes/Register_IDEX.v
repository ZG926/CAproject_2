module Register_IDEX (
	clk_i,
	start_i,
	stall_i,
	RS1Data_i,
	RS2Data_i,
	SignExtended_i,
	funct_i,
	RdAddr_i,
	RS1Addr_i,
	RS2Addr_i,
	RS1Data_o,
	RS2Data_o,
	SignExtended_o,
	funct_o,
	RdAddr_o,
	RS1Addr_o,
	RS2Addr_o,
	RegWrite_i,
	MemtoReg_i,
	MemRead_i,
	MemWrite_i,
	ALUOp_i,
	ALUSrc_i,
	RegWrite_o,
	MemtoReg_o,
	MemRead_o,
	MemWrite_o,
	ALUOp_o,
	ALUSrc_o
);

input clk_i, start_i,stall_i;
input [31:0] RS1Data_i, RS2Data_i, SignExtended_i;
input [9:0] funct_i;
input [4:0] RdAddr_i,RS1Addr_i,RS2Addr_i;

input [1:0] ALUOp_i;
input RegWrite_i, MemtoReg_i, MemRead_i, MemWrite_i, ALUSrc_i;	

output [31:0] RS1Data_o, RS2Data_o, SignExtended_o;
output [9:0] funct_o;
output [4:0] RdAddr_o,RS1Addr_o,RS2Addr_o;

output [1:0] ALUOp_o;
output RegWrite_o, MemtoReg_o, MemRead_o, MemWrite_o, ALUSrc_o;	

reg [31:0] RS1Data_o, RS2Data_o, SignExtended_o;
reg [9:0] funct_o;
reg [4:0] RdAddr_o,RS1Addr_o,RS2Addr_o;

reg [1:0] ALUOp_o;
reg RegWrite_o, MemtoReg_o, MemRead_o, MemWrite_o, ALUSrc_o;	

always @(posedge clk_i) begin
	if (stall_i) begin
		
	end
	else begin
		if (start_i) begin 
			RS1Data_o 		    <= RS1Data_i;
			RS2Data_o 		    <= RS2Data_i;
			SignExtended_o 	    <= SignExtended_i;
			funct_o				<= funct_i;
			RdAddr_o       		<= RdAddr_i;
			RS1Addr_o       	<= RS1Addr_i;
			RS2Addr_o       	<= RS2Addr_i;
		
			RegWrite_o          <= RegWrite_i; 
			MemtoReg_o          <= MemtoReg_i;
			MemRead_o           <= MemRead_i; 
			MemWrite_o          <= MemWrite_i;
			ALUOp_o             <= ALUOp_i;
			ALUSrc_o            <= ALUSrc_i;

		end 
		else begin
			RS1Data_o 		    <= RS1Data_o;
			RS2Data_o 		    <= RS2Data_o;
			SignExtended_o 	    <= SignExtended_o;
			funct_o				<= funct_o;
			RdAddr_o            <= RdAddr_o;
			RS1Addr_o       	<= RS1Addr_o;
			RS2Addr_o       	<= RS2Addr_o;
		
			RegWrite_o          <= RegWrite_o; 
			MemtoReg_o          <= MemtoReg_o;
			MemRead_o           <= MemRead_o; 
			MemWrite_o          <= MemWrite_o;
			ALUOp_o             <= ALUOp_o;
			ALUSrc_o            <= ALUSrc_o;
		end 
			
	end	
end

endmodule


