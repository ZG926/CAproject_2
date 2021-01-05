`define R_Type 2'b10
`define I_Type 2'b00
`define S_Type 2'b01
`define SB_Type 2'b11
`define AND		4'b0000
`define XOR		4'b0001
`define SLL		4'b0010
`define ADD 	4'b0011
`define SUB		4'b0100
`define MUL 	4'b0101
`define ADDI 	4'b0110
`define SRAI 	4'b0111
`define LW		4'b1000
`define SW		4'b1001
`define BEQ		4'b1010

module ALU_Control(
    funct_i,	
    ALUOp_i,	
    ALUCtrl_o 	
);

// Ports
input 	[9:0] 		funct_i;
input 	[1:0] 		ALUOp_i;
output 	[3:0] 		ALUCtrl_o;

reg 	[3:0] 		ALUCtrl_o;

always @(ALUOp_i or funct_i) begin
	case(ALUOp_i) 
		// AND XOR SLL ADD SUB MUL 
		`R_Type: begin
			case(funct_i)
				10'b0000000111	: ALUCtrl_o <= `AND;
				10'b0000000100	: ALUCtrl_o <= `XOR;
				10'b0000000001	: ALUCtrl_o <= `SLL;
				10'b0000000000	: ALUCtrl_o <= `ADD;
				10'b0100000000	: ALUCtrl_o <= `SUB;
				10'b0000001000 	: ALUCtrl_o <= `MUL;
			endcase
		end

		// ADDI SRAI LW
		`I_Type: begin
			case(funct_i[2:0])
				3'b000:	ALUCtrl_o <= `ADDI;
				3'b101: ALUCtrl_o <= `SRAI;
				3'b010: ALUCtrl_o <= `LW;
			endcase
		end

		// SW
		`S_Type: begin
			ALUCtrl_o <= `SW;
		end

		// BEQ
		`SB_Type: begin
			ALUCtrl_o <= `BEQ;
		end
	endcase
end

endmodule
