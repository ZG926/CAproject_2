module dcache_sram
(
    clk_i,
    rst_i,
    addr_i,
    tag_i,
    data_i,
    enable_i,
    write_i,
    tag_o,
    data_o,
    hit_o
);

// I/O Interface from/to controller
input              clk_i;
input              rst_i;
input    [3:0]     addr_i;
input    [24:0]    tag_i;
input    [255:0]   data_i;
input              enable_i;
input              write_i;

output   [24:0]    tag_o;
output   [255:0]   data_o;
output             hit_o;


// Memory
reg      [24:0]    tag [0:15][0:1];    
reg      [255:0]   data[0:15][0:1];
//reg                 hit_o;
//reg       [24:0]    tag_o;
//reg      [255:0]   data_o;


integer            i, j;

reg [15:0] LRU;
integer index;
//always@(posedge clk_i) begin
//    index <= addr_i[3]*8+addr_i[2]*4+addr_i[1]*2+addr_i[0]*1;    
//end

// Write Data      
// 1. Write hit
// 2. Read miss: Read from memory
always@(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
        for (i=0;i<16;i=i+1) begin
            for (j=0;j<2;j=j+1) begin
                tag[i][j] <= 25'b0;
                data[i][j] <= 256'b0;
            end
        end
        //initialize LRU(zg)
        LRU <= 16'b0;
    end
    if (enable_i && write_i) begin
        // TODO: Handle your write of 2-way associative cache + LRU here
        if (tag[addr_i][0][22:0] == tag_i[22:0]) begin
            data[addr_i][0] <= data_i;
            tag[addr_i][0] <= tag_i;
            tag[addr_i][0][23] <= 1'b1;
            LRU[addr_i] <= 1'b1;
        end
        else if (tag[addr_i][1][22:0] == tag_i[22:0]) begin
            data[addr_i][1] <= data_i;
            tag[addr_i][1] <= tag_i;
            tag[addr_i][0][23] <= 1'b1;
            LRU[addr_i] <= 1'b0;
        end
        else begin
            data[addr_i][LRU[addr_i]] <= data_i;
            tag[addr_i][LRU[addr_i]] <= tag_i;
            LRU[addr_i] <= ~LRU[addr_i];
        end   
    end
end

// Read Data      
// TODO: tag_o=? data_o=? hit_o=?
wire equal1,valid1,equal2,valid2,result1,result2;
assign equal1 = (tag_i[22:0] == tag[addr_i][0][22:0])?1'b1:1'b0;
assign equal2 = (tag_i[22:0] == tag[addr_i][1][22:0])?1'b1:1'b0;
assign result1 = equal1 & tag[addr_i][0][24];
assign result2 = equal2 & tag[addr_i][1][24];
assign hit_o = result1 | result2;
assign data_o = (hit_o)?((result1)?data[addr_i][0]:data[addr_i][1]):data[addr_i][LRU[addr_i]];
assign tag_o = (hit_o)?((result1)?tag[addr_i][0]:tag[addr_i][1]):tag[addr_i][LRU[addr_i]];

always @(posedge clk_i or posedge rst_i) begin
    if (hit_o) begin
        if (result1) begin
            LRU[addr_i] <= 1'b1;
        end
        else begin
            LRU[addr_i] <= 1'b0;
        end
    end
end
/*
always @(posedge clk_i) begin
    if (enable_i) begin
        if (tag[addr_i][0][22:0] == tag_i) begin
            data_o <=  data[addr_i][0] ;
            tag_o <=tag[addr_i][0] ;
            hit_o <= 1'b1;
            LRU[addr_i] <= 1'b1;//implement LRU
        end
        else if (tag[addr_i][1][22:0] == tag_i) begin
            data_o <= data[addr_i][1] ;
            tag_o <= tag[addr_i][1] ;
            hit_o <= 1'b1;
            LRU[addr_i] <= 1'b0;//implement LRU
        end
        else begin
            data_o <= data[addr_i][LRU[addr_i]];
            tag_o <= tag[addr_i][LRU[addr_i]] ;
            hit_o <= 1'b0;
        end 
    end
end
*/


endmodule