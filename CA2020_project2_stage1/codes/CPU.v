module CPU(
    clk_i, 
    rst_i,
    start_i
);
// Ports
input               clk_i;
input               rst_i;
input               start_i;

// PC
wire    [31:0]      PC_o,PC_Four,PC_Branch;
wire    [31:0]      instr;

// Control
wire                Ctrl_RegWrite,Ctrl_MemtoReg,Ctrl_MemRead,Ctrl_MemWrite,Ctrl_ALUSrc,Ctrl_Branch;
wire    [1:0]       Ctrl_ALUOp;

// ALU_Control
wire    [3:0]       ALUCtrl;

// Registers
wire    [31:0]      RS2data,RS1data;

// ALU
wire    [31:0]      ALU_Result;

//Sign_Extend
wire    [31:0]      SignExtend_Result;

// MUX32
wire    [31:0]      MUX_ALUSRC_Result;
wire    [31:0]      MUX_MemtoReg_Result;
wire    [31:0]      MUX_PC_Result;

// Data_Memory
wire    [31:0]      MemRead_Result;

// Register_IFID
wire    [31:0]      IFID_instr;
wire    [31:0]      IFID_pc;

// Register_IDEX
wire    [31:0]      IDEX_RS1Data,IDEX_RS2Data;
wire    [31:0]      IDEX_SignExtend;
wire    [9:0]       IDEX_funct;
wire    [4:0]       IDEX_RDAddr,IDEX_RS1Addr,IDEX_RS2Addr;  
wire    [1:0]       IDEX_ALUOp;
wire                IDEX_RegWrite, IDEX_MemtoReg, IDEX_MemRead, IDEX_MemWrite, IDEX_ALUSrc;

// Register_EXMEM
wire    [31:0]      EXMEM_ALUResult,EXMEM_MemWriteData;
wire    [4:0]       EXMEM_RDAddr;
wire                EXMEM_RegWrite,EXMEM_MemtoReg, EXMEM_MemRead, EXMEM_MemWrite;

// Register_MEMWB
wire    [31:0]      MEMWB_ALUResult,MEMWB_MemReadData;
wire    [4:0]       MEMWB_RDAddr;
wire                MEMWB_RegWrite, MEMWB_MemtoReg;

// Forwarding_Unit
wire    [1:0]       Forward_A;
wire    [1:0]       Forward_B;
// MUX32_4
wire    [31:0]      Forward_MUX_A_Result;
wire    [31:0]      Forward_MUX_B_Result;

// And
wire                Flush;

// Equal
wire                Equal_Result;

// Shift_Left
wire    [31:0]      ShiftLeft_Result;

//Hazard_Detection
wire PCWrite;
wire Stall;
wire NoOp;

Adder Add_PC(
    .data1_in   (PC_o),       
    .data2_in   (32'd4),            
    .data_o     (PC_Four)   
);

Adder Add_Branch(
    .data1_in   (ShiftLeft_Result),       
    .data2_in   (IFID_pc),            
    .data_o     (PC_Branch)   
);

ALU ALU(
    .data1_i    (Forward_MUX_A_Result),                  
    .data2_i    (MUX_ALUSRC_Result),
    .ALUCtrl_i  (ALUCtrl),                
    .data_o     (ALU_Result)            
);

ALU_Control ALU_Control(
    .funct_i    (IDEX_funct),  
    .ALUOp_i    (IDEX_ALUOp),                        
    .ALUCtrl_o  (ALUCtrl)                       
);

And And(
    .data1_i(Ctrl_Branch),
    .data2_i(Equal_Result),
    .data_o(Flush)
);

Control Control(
    .Op_i(IFID_instr[6:0]), 
    .NoOp_i(NoOp),      
    .RegWrite_o(Ctrl_RegWrite),
    .MemtoReg_o(Ctrl_MemtoReg),
    .MemRead_o(Ctrl_MemRead),
    .MemWrite_o(Ctrl_MemWrite),
    .ALUOp_o(Ctrl_ALUOp),    
    .ALUSrc_o(Ctrl_ALUSrc),
    .Branch_o(Ctrl_Branch)
);

Data_Memory Data_Memory(
    .clk_i(clk_i), 
    .addr_i(EXMEM_ALUResult), 
    .MemRead_i(EXMEM_MemRead),
    .MemWrite_i(EXMEM_MemWrite),
    .data_i(EXMEM_MemWriteData),
    .data_o(MemRead_Result)
);

Equal Equal(
    .data1_i(RS1data),
    .data2_i(RS2data),
    .equal_o(Equal_Result)
);

Instruction_Memory Instruction_Memory(
    .addr_i     (PC_o),     
    .instr_o    (instr)            
);

MUX32 MUX_ALUSrc(
    .data1_i    (Forward_MUX_B_Result),          
    .data2_i    (IDEX_SignExtend),    
    .select_i   (IDEX_ALUSrc),               
    .data_o     (MUX_ALUSRC_Result)              
);

MUX32 MUX_MemtoReg(
    .data1_i    (MEMWB_ALUResult),          
    .data2_i    (MEMWB_MemReadData),    
    .select_i   (MEMWB_MemtoReg),               
    .data_o     (MUX_MemtoReg_Result)  
);

MUX32 MUX_PC(
    .data1_i    (PC_Four),          
    .data2_i    (PC_Branch),    
    .select_i   (Flush),               
    .data_o     (MUX_PC_Result)  
);

PC PC(
    .clk_i      (clk_i),     
    .rst_i      (rst_i),     
    .start_i    (start_i), 
    .PCWrite_i  (PCWrite),    
    .pc_i       (MUX_PC_Result),     
    .pc_o       (PC_o)           
);

Registers Registers(
    .clk_i      (clk_i),    
    .RS1addr_i  (IFID_instr[19:15]),         
    .RS2addr_i  (IFID_instr[24:20]),         
    .RDaddr_i   (MEMWB_RDAddr),         
    .RDdata_i   (MUX_MemtoReg_Result),            
    .RegWrite_i (MEMWB_RegWrite),             
    .RS1data_o  (RS1data),              
    .RS2data_o  (RS2data)               
);

Register_IFID IFID(
    .clk_i(clk_i),
    .start_i(start_i),
    .instr_i(instr),
    .pc_i(PC_o),
    .Stall_i(Stall),
    .Flush_i(Flush),
    .instr_o(IFID_instr),
    .pc_o(IFID_pc)
);

Register_IDEX IDEX(
    .clk_i(clk_i), 
    .start_i(start_i),
    .RS1Data_i(RS1data), 
    .RS2Data_i(RS2data),
    .SignExtended_i(SignExtend_Result), 
    .funct_i({IFID_instr[31:25],IFID_instr[14:12]}),
    .RdAddr_i(IFID_instr[11:7]),
    .RS1Addr_i(IFID_instr[19:15]),
    .RS2Addr_i(IFID_instr[24:20]),

    .RS1Data_o(IDEX_RS1Data),
    .RS2Data_o(IDEX_RS2Data),
    .SignExtended_o(IDEX_SignExtend),
    .funct_o(IDEX_funct),
    .RdAddr_o(IDEX_RDAddr),
    .RS1Addr_o(IDEX_RS1Addr),
    .RS2Addr_o(IDEX_RS2Addr),

    .RegWrite_i(Ctrl_RegWrite), 
    .MemtoReg_i(Ctrl_MemtoReg), 
    .MemRead_i(Ctrl_MemRead),  
    .MemWrite_i(Ctrl_MemWrite), 
    .ALUOp_i(Ctrl_ALUOp), 
    .ALUSrc_i(Ctrl_ALUSrc),

    .RegWrite_o(IDEX_RegWrite),
    .MemtoReg_o(IDEX_MemtoReg),
    .MemRead_o(IDEX_MemRead),
    .MemWrite_o(IDEX_MemWrite),
    .ALUOp_o(IDEX_ALUOp),
    .ALUSrc_o(IDEX_ALUSrc)
);

Register_EXMEM EXMEM(
    .clk_i(clk_i),
    .start_i(start_i),
    .ALU_Result_i(ALU_Result),
    .MemWrite_Data_i(Forward_MUX_B_Result),
    .RdAddr_i(IDEX_RDAddr),
    .ALU_Result_o(EXMEM_ALUResult),
    .MemWrite_Data_o(EXMEM_MemWriteData),
    .RdAddr_o(EXMEM_RDAddr),
    .RegWrite_i(IDEX_RegWrite), 
    .MemtoReg_i(IDEX_MemtoReg), 
    .MemRead_i(IDEX_MemRead),  
    .MemWrite_i(IDEX_MemWrite), 
    .RegWrite_o(EXMEM_RegWrite), 
    .MemtoReg_o(EXMEM_MemtoReg), 
    .MemRead_o(EXMEM_MemRead),  
    .MemWrite_o(EXMEM_MemWrite)
);

Register_MEMWB MEMWB(
    .clk_i(clk_i), 
    .start_i(start_i),
    .MemAddr_i(EXMEM_ALUResult),
    .MemRead_Data_i(MemRead_Result),
    .RdAddr_i(EXMEM_RDAddr),
    .MemAddr_o(MEMWB_ALUResult),
    .MemRead_Data_o(MEMWB_MemReadData),
    .RdAddr_o(MEMWB_RDAddr),
    .RegWrite_i(EXMEM_RegWrite),
    .MemtoReg_i(EXMEM_MemtoReg),
    .RegWrite_o(MEMWB_RegWrite),
    .MemtoReg_o(MEMWB_MemtoReg)
);

Sign_Extend Sign_Extend(
    .data_i     (IFID_instr[31:0]),        
    .data_o     (SignExtend_Result)     
);
  
Shift_Left Shift_Left(
    .data_i     (SignExtend_Result), 
    .data_o     (ShiftLeft_Result)
);

Forwarding_Unit Forwarding_Unit(
    .EX_Rs1_i (IDEX_RS1Addr),
    .EX_Rs2_i (IDEX_RS2Addr),
    .MEM_RegWrite_i (EXMEM_RegWrite),
    .MEM_Rd_i (EXMEM_RDAddr),
    .WB_RegWrite_i (MEMWB_RegWrite),
    .WB_Rd_i (MEMWB_RDAddr),
    .Forward_A_o (Forward_A),
    .Forward_B_o (Forward_B)
);

MUX32_4 Forward_MUX_A(
    .Forward_i (Forward_A),
    .EX_RS_Data_i (IDEX_RS1Data),
    .MEM_ALU_Result_i (EXMEM_ALUResult),
    .WB_WriteData_i (MUX_MemtoReg_Result),
    .MUX_Result_o (Forward_MUX_A_Result)
);

MUX32_4 Forward_MUX_B(
    .Forward_i (Forward_B),
    .EX_RS_Data_i (IDEX_RS2Data),
    .MEM_ALU_Result_i (EXMEM_ALUResult),
    .WB_WriteData_i (MUX_MemtoReg_Result),
    .MUX_Result_o (Forward_MUX_B_Result)
);

Hazard_Detection Hazard_Detection(
    .RS1addr_i(IFID_instr[19:15]),
    .RS2addr_i(IFID_instr[24:20]),
    .MemRead_i(IDEX_MemRead), 
    .RdAddr_i(IDEX_RDAddr),
    .PCWrite_o(PCWrite),
    .Stall_o(Stall),
    .NoOp_o(NoOp)
);



endmodule

