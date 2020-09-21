module top_elastic
  (
   input wire [31:0] t0_data,
   input wire        t0_valid,
   output wire       t0_ready,
   output reg [31:0] i0_data,
   output reg        i0_valid,
   input wire        i0_ready,
   input wire [32:0] t1_data,
   input wire        t1_valid,
   output wire       t1_ready,
   output reg [32:0] i1_data,
   output reg        i1_valid,
   input wire        i1_ready,
   input wire [64:0] t2_data,
   input wire        t2_valid,
   output wire       t2_ready,
   output reg [64:0] i2_data,
   output reg        i2_valid,
   input wire        i2_ready,
   input wire        clk,
   input wire        rstf
   );


`ifdef EB0
   assign t0_ready = rstf ? i0_ready:0;
   
   always @(*) begin
      i0_data = rstf ? t0_data << 2 : 0;
      i0_valid = rstf ? t0_valid : 0;
   end

   assign t1_ready = rstf ? i1_ready:0;
   
   always @(*) begin
      i1_data = rstf ? t1_data << 2 : 0;
      i1_valid = rstf ? t1_valid : 0;
   end

   assign t2_ready = rstf ? i2_ready:0;
   
   always @(*) begin
      i2_data = rstf ? t2_data << 2 : 0;
      i2_valid = rstf ? t2_valid : 0;
   end
`else

   logic      data_en0;
   assign t0_ready = ~rstf ? 0:~i0_valid | i0_ready;

   assign data_en0 = t0_valid & t0_ready;

   always @(posedge clk or negedge rstf) begin
      if(!rstf) begin
         i0_data <= 0;
         i0_valid <= 0;
      end
      else begin
         if(data_en0)
           i0_data <= t0_data<<2;
         i0_valid <= ~t0_ready | t0_valid;
      end
   end // always @ (posedge clk or negedge rstf)

   logic      data_en1;
   assign t1_ready = ~rstf ? 0:~i1_valid | i1_ready;

   assign data_en1 = t1_valid & t1_ready;

   always @(posedge clk or negedge rstf) begin
      if(!rstf) begin
         i1_data <= 0;
         i1_valid <= 0;
      end
      else begin
         if(data_en1)
           i1_data <= t1_data<<2;
         i1_valid <= ~t1_ready | t1_valid;
      end
   end // always @ (posedge clk or negedge rstf)

   logic      data_en2;
   assign t2_ready = ~rstf ? 0:~i2_valid | i2_ready;

   assign data_en2 = t2_valid & t2_ready;

   always @(posedge clk or negedge rstf) begin
      if(!rstf) begin
         i2_data <= 0;
         i2_valid <= 0;
      end
      else begin
         if(data_en2)
           i2_data <= t2_data<<2;
         i2_valid <= ~t2_ready | t2_valid;
      end
   end
`endif
endmodule
