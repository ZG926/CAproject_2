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
reg                 hit_o;
reg       [24:0]    tag_o;
reg      [255:0]   data_o;


integer            i, j;

reg [15:0] LRU;
integer index;
always@(addr_i) begin
    index <= addr_i[3]*8+addr_i[2]*4+addr_i[1]*2+addr_i[0]*1;    
end

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
        if (tag[index][0][22:0] == tag_i) begin
            data[index][0] <= data_i;
            tag[index][0] <= tag_i;
            hit_o <= 1'b1;
            tag_o <= 25'b0;
            data_o <= 256'b0;
        end
        else if (tag[index][1][22:0] == tag_i) begin
            data[index][1] <= data_i;
            tag[index][1] <= tag_i;
            hit_o <= 1'b1;
            tag_o <= 25'b0;
            data_o <= 256'b0;
        end
        else begin
            data[index][LRU[index]] <= data_i;
            tag[index][LRU[index]] <= tag_i;
            hit_o <= 1'b1;
            tag_o <= 25'b0;
            data_o <= 256'b0;
            LRU[index] = ~LRU[index];
        end   
    end
end

// Read Data      
// TODO: tag_o=? data_o=? hit_o=?
always @(posedge clk_i ) begin
    
    if (enable_i) begin
        if (tag[index][0][22:0] == tag_i) begin
            data_o <=  data[index][0] ;
            tag_o <=tag[index][0] ;
            hit_o = 1'b1;
            LRU[index] = 1'b1;
        end
        else if (tag[index][1][22:0] == tag_i) begin
            data_o <= data[index][1] ;
            tag_o <= tag[index][1] ;
            hit_o = 1'b1;
            LRU[index] = 1'b0;
        end
        else begin
            data_o <= data[index][LRU[index]];
            tag_o <= tag[index][LRU[index]] ;
            hit_o = 1'b0;
        end 
    end
end


endmodule
