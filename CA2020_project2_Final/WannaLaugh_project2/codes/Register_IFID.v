module Register_IFID(
	clk_i,
	start_i,
	stall_i,
    instr_i,
    pc_i,
    Stall_i,
    Flush_i,
    instr_o,
    pc_o
);

input			clk_i,start_i,stall_i;
input   [31:0]  instr_i;
input	[31:0]	pc_i; 
input 			Stall_i,Flush_i;

output	[31:0]	instr_o;
output	[31:0]	pc_o; 

reg 	[31:0] 	instr_o;
reg		[31:0]	pc_o; 

always @(posedge clk_i) begin
	if (stall_i) begin
		
	end
	else begin
		if (~start_i) begin
			instr_o <= 32'b0;
			pc_o <= 32'b0;
		end
		else if (Flush_i) begin
			instr_o <= 32'b0;
			pc_o <= 32'b0;
		end
		else if (Stall_i) begin
			instr_o <= instr_o;
			pc_o <= pc_o;
		end
		else begin
			instr_o <= instr_i;
			pc_o <= pc_i;
		end
	end
	
end

endmodule
