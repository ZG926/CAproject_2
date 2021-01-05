`define R_Type 2'b10
`define I_Type 2'b00
`define S_Type 2'b01
`define SB_Type 2'b11

module Control(
	Op_i,		
	NoOp_i,
	RegWrite_o,
	MemtoReg_o,
	MemRead_o,
	MemWrite_o,
	ALUOp_o,	
	ALUSrc_o,
	Branch_o
);

// Ports
input 	[6:0]		Op_i;	
input 				NoOp_i;

output RegWrite_o, MemtoReg_o, MemRead_o, MemWrite_o, ALUSrc_o, Branch_o;
output 	[1:0]		ALUOp_o;

reg RegWrite_o, MemtoReg_o, MemRead_o, MemWrite_o, ALUSrc_o, Branch_o;
reg 	[1:0]		ALUOp_o;

always @(Op_i or NoOp_i) begin
	if (NoOp_i) begin
		RegWrite_o	= 1'b0;
		MemtoReg_o	= 1'b0;
		MemRead_o	= 1'b0;
		MemWrite_o	= 1'b0;
		ALUOp_o		= `R_Type;
		ALUSrc_o	= 1'b0;
		Branch_o	= 1'b0;
	end
	else begin
		case(Op_i)
			// R-Type (Arithmetic)
			7'b0110011: begin
				RegWrite_o	= 1'b1;
				MemtoReg_o	= 1'b0;
				MemRead_o	= 1'b0;
				MemWrite_o	= 1'b0;
				ALUOp_o		= `R_Type;
				ALUSrc_o	= 1'b0;
				Branch_o	= 1'b0;
			end

			// I-Type (Immediate Arithmetic) 
			7'b0010011: begin
				RegWrite_o	= 1'b1;
				MemtoReg_o	= 1'b0;
				MemRead_o	= 1'b0;
				MemWrite_o	= 1'b0;
				ALUOp_o		= `I_Type;
				ALUSrc_o	= 1'b1;
				Branch_o	= 1'b0;
			end

			// I-Type (Load) 
			7'b0000011: begin
				RegWrite_o	= 1'b1;
				MemtoReg_o	= 1'b1;
				MemRead_o	= 1'b1;
				MemWrite_o	= 1'b0;
				ALUOp_o		= `I_Type;
				ALUSrc_o	= 1'b1;
				Branch_o	= 1'b0;
			end

			// S-Type (Store)
			7'b0100011: begin
				RegWrite_o	= 1'b0;
				MemtoReg_o	= 1'b0;
				MemRead_o	= 1'b0;
				MemWrite_o	= 1'b1;
				ALUOp_o		= `S_Type;
				ALUSrc_o	= 1'b1;
				Branch_o	= 1'b0;
			end

			7'b1100011: begin
				RegWrite_o	= 1'b0;
				MemtoReg_o	= 1'b0;
				MemRead_o	= 1'b0;
				MemWrite_o	= 1'b0;
				ALUOp_o		= `SB_Type;
				ALUSrc_o	= 1'b0;
				Branch_o	= 1'b1;
			end

			7'b0000000: begin
				RegWrite_o	= 1'b0;
				MemtoReg_o	= 1'b0;
				MemRead_o	= 1'b0;
				MemWrite_o	= 1'b0;
				ALUOp_o		= `SB_Type;
				ALUSrc_o	= 1'b0;
				Branch_o	= 1'b0;
			end
		endcase	
		
	end
end

endmodule
