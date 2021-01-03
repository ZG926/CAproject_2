module Register_EXMEM (
    clk_i,
    start_i,
    stall_i,

    // ALU Result & Data & Instruction Address
    ALU_Result_i,
    MemWrite_Data_i,
    RdAddr_i,

    ALU_Result_o,
    MemWrite_Data_o,
    RdAddr_o,

	// Control 
    RegWrite_i, 
    MemtoReg_i, 
    MemRead_i,  
    MemWrite_i, 

    RegWrite_o, 
    MemtoReg_o, 
    MemRead_o,  
    MemWrite_o
     
);
input               clk_i,start_i,stall_i;
input   [31:0]      ALU_Result_i, MemWrite_Data_i;
input   [4:0]       RdAddr_i;
input RegWrite_i, MemtoReg_i, MemRead_i, MemWrite_i;  

output   [31:0]      ALU_Result_o, MemWrite_Data_o;
output   [4:0]       RdAddr_o;
output RegWrite_o, MemtoReg_o, MemRead_o, MemWrite_o;  

reg   [31:0]      ALU_Result_o, MemWrite_Data_o;
reg   [4:0]       RdAddr_o;
reg RegWrite_o, MemtoReg_o, MemRead_o, MemWrite_o;  

always @(posedge clk_i) begin
    if (stall_i) begin
        
    end
    else begin
        if(start_i) begin
            ALU_Result_o        <= ALU_Result_i; 
            MemWrite_Data_o     <= MemWrite_Data_i;  
            RdAddr_o           <= RdAddr_i;   

            RegWrite_o          <= RegWrite_i; 
            MemtoReg_o          <= MemtoReg_i;
            MemRead_o           <= MemRead_i; 
            MemWrite_o          <= MemWrite_i;

        end
        else begin
            ALU_Result_o        <= ALU_Result_o; 
            MemWrite_Data_o     <= MemWrite_Data_o;  
            RdAddr_o           <= RdAddr_o;   

            RegWrite_o          <= RegWrite_o; 
            MemtoReg_o          <= MemtoReg_o;
            MemRead_o           <= MemRead_o; 
            MemWrite_o          <= MemWrite_o;

        end 
        
    end
end

endmodule
