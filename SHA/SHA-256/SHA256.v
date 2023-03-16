module SHA256(
   input clk,
   input rst_n,
   input init,
   input load,
   input fetch,
   input [15:0] idata, //#31,15
   output ack,
   //output valid,
   output [15:0] odata,
   output [7:0] led,
   output [15:0] debug
);   

wire [31:0] Hash0;
wire [31:0] Hash1;
wire [31:0] Hash2;
wire [31:0] Hash3;
wire [31:0] Hash4;
wire [31:0] Hash5;
wire [31:0] Hash6;
wire [31:0] Hash7;

wire busy;
wire EN;

//debug用 
reg debug0;
reg debug1;
reg debug2;
reg debug3;
reg debug4;
reg debug5;
reg debug6;
reg debug7;

//#追加
wire [31:0] idata32;

assign debug[3:0] = odata[3:0];
assign debug[7:4] = odata[11:8];
assign debug[11:8] = idata[3:0];
assign debug[12] = clk;
assign debug[13] = ack;
assign debug[14] = EN;
assign debug[15] = busy;

always @(posedge clk or negedge rst_n) begin
   if(~rst_n) debug0 <= 0;
   else if (Hash0 == 32'hba7816bf) debug0 <= 1;
   else debug0 <= debug0;
end
assign led[0] = debug0;

always @(posedge clk or negedge rst_n) begin
   if(~rst_n) debug1 <= 0;
   else if (Hash1 == 32'h8f01cfea) debug1 <= 1;
   else debug1 <= debug1;
end
assign led[1] = debug1;

always @(posedge clk or negedge rst_n) begin
   if(~rst_n) debug2 <= 0;
   else if (Hash2 == 32'h414140de) debug2 <= 1;
   else debug2 <= debug2;
end
assign led[2] = debug2;

always @(posedge clk or negedge rst_n) begin
   if(~rst_n) debug3 <= 0;
   else if (Hash3 == 32'h5dae2223) debug3 <= 1;
   else debug3 <= debug3;
end
assign led[3] = debug3;


always @(posedge clk or negedge rst_n) begin
   if(~rst_n) debug4 <= 0;
   else if (Hash4 == 32'hb00361a3) debug4 <= 1;
   else debug4 <= debug4;
end
assign led[4] = debug4;


always @(posedge clk or negedge rst_n) begin
   if(~rst_n) debug5 <= 0;
   else if (Hash5 == 32'h96177a9c) debug5 <= 1;
   else debug5 <= debug5;
end
assign led[5] = debug5;


always @(posedge clk or negedge rst_n) begin
   if(~rst_n) debug6 <= 0;
   else if (Hash6 == 32'hb410ff61) debug6 <= 1;
   else debug6 <= debug6;
end
assign led[6] = debug6;


always @(posedge clk or negedge rst_n) begin
   if(~rst_n) debug7 <= 0;
   else if (Hash7 == 32'hf20015ad) debug7 <= 1;
   else debug7 <= debug7;
end
assign led[7] = debug7;




/***************************** インスタンス宣言 ******************************************************/

SHA256_INTERFACE SHA256_INTERFACE(
   .clk(clk), .rst_n(rst_n),
   .load(load), .fetch(fetch),
   .odata(odata),
   .ack(ack), .busy(busy),
   .EN(EN),
   .Hash0(Hash0), .Hash1(Hash1), .Hash2(Hash2), .Hash3(Hash3),
   .Hash4(Hash4), .Hash5(Hash5), .Hash6(Hash6), .Hash7(Hash7),
   .idata(idata), .idata32(idata32) //#追加
);

SHA256_CORE SHA256_CORE(
   .clk(clk), .rst_n(rst_n),
   .busy(busy), .EN(EN),
   .init(init), //.valid(valid),
   .Hash0(Hash0), .Hash1(Hash1), .Hash2(Hash2), .Hash3(Hash3),
   .Hash4(Hash4), .Hash5(Hash5), .Hash6(Hash6), .Hash7(Hash7),
   .idata(idata32) //#追加,idataを削除
);

endmodule
