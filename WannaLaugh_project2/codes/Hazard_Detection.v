module Hazard_Detection
(
    RS1addr_i,
    RS2addr_i,
    MemRead_i, 
    RdAddr_i,
    PCWrite_o,
    Stall_o,
    NoOp_o
);

// Ports
input   [4:0]       RS1addr_i;
input   [4:0]       RS2addr_i;
input MemRead_i;
input [4:0] RdAddr_i;
output PCWrite_o;
output Stall_o;
output NoOp_o;
reg PCWrite_o;
reg Stall_o;
reg NoOp_o;
//wire [4:0] difference1 = RS1addr_i - rd;
//wire[4:0] difference2 = RS2addr_i - rd;
always @(RS1addr_i or RS2addr_i or MemRead_i or RdAddr_i)
begin
	if (MemRead_i) begin
		if (RdAddr_i == RS1addr_i)begin
			PCWrite_o <= 0;
			Stall_o <= 1;
			NoOp_o <= 1;
			////$display(data_o);
		end
		else if (RdAddr_i == RS2addr_i) begin
			PCWrite_o <= 0;
			Stall_o <= 1;
			NoOp_o <= 1;
			////$display(data_o);
		end
		else begin
			PCWrite_o <= 1;
			Stall_o <= 0;
			NoOp_o <= 0;
		end
	end
	else begin
		PCWrite_o <= 1;
		Stall_o <= 0;
		NoOp_o <= 0;
	end
end

endmodule