////////////////////////////////////////////////////////////////////////////////
//
// Arrive Technologies
//
// Filename     : convclk_grayffrd.v
// Description  : 
//      Fifo control with read and write @ diffrent clk domain
//      without losing data if depend on full and notempty signals 
//
//      A set of 1) convclk_grayffctrl.v - this is a sample cover
//               2) convclk_grayffwr.v - this is used in write clock domain
//               3) convclk_grayffrd.v - this is used in read clock domain
//
// Author       : Cao Trang Minh Tu
// Created On   : Mon Sep 08 14:39:59 2008
// History (Date, Changed By)
//
//  Origin developed by Nguyen Van Cuong, Tue Nov 21 16:16:20 2006
//      Maximum scale between 2 clk is 31 times
//      LEN >= 5 + 4*(wclk/rclk), with 4*(wclk/rclk) is integer  
//      eg: 4*(wclk/rclk) = 4.9 ~ 4 => LEN >= 5+4
//
//  Fri Sep 26 16:44:48 2008, ddduc
//      Reviewed and sanity check for macro use
//  Thu Aug 20 10:18:19 2015, cuongnv@HW-NVCUONG
//      change rst_ to rst
////////////////////////////////////////////////////////////////////////////////

module convclk_grayffrd
    (
     rdclk,
     rdrst,

     fiford,
     fifoflush,
     fifonemp,
     rdfifolen,
     rdpnt_gray,     //use to synchronize @ wrclk
     
     rdaddr,
     read,

     // Write pointer @ wrclk
     wrpnt_gray
     );

////////////////////////////////////////////////////////////////////////////////
// Parameter declarations
parameter   ADDRB = 4;
parameter   FSHW = 2;  //normal = 2, improve timing = 3 

////////////////////////////////////////////////////////////////////////////////
// Port declarations
input               rdclk;
input               rdrst;

input               fiford;
input               fifoflush;
output              fifonemp;
output [ADDRB:0]    rdfifolen;  // for detailed internal status
output [ADDRB:0]    rdpnt_gray;

output [ADDRB-1:0]  rdaddr;
output              read;

input [ADDRB:0]     wrpnt_gray;
////////////////////////////////////////////////////////////////////////////////
// Output declarations


////////////////////////////////////////////////////////////////////////////////
// Local logic and instantiation
//synchronize read pointer
reg [ADDRB:0]       wrpnt_gray1= {(ADDRB+1){1'b0}};
reg [ADDRB:0]       wrpnt_gray2= {(ADDRB+1){1'b0}};
//always @ ( posedge rdclk or negedge rdrst_ )
always @ ( posedge rdclk)
    //if(rdrst)
    //    begin
    //    wrpnt_gray1  <= {(ADDRB+1){1'b0}};
    //    wrpnt_gray2  <= {(ADDRB+1){1'b0}};
    //    end
    //else
        begin
        wrpnt_gray1  <= wrpnt_gray;
        wrpnt_gray2  <= wrpnt_gray1;      
        end

reg [ADDRB:0] wrpnt_bin = {(ADDRB+1){1'b0}};    //write pointer after decode Gray code
reg [ADDRB:0] wrpnt_bin_n= {(ADDRB+1){1'b0}};    //write pointer after decode Gray code
integer       i;
always @ (wrpnt_gray2)  for (i=0;i<(ADDRB+1);i=i+1) wrpnt_bin_n[i] = ^(wrpnt_gray2[ADDRB:0]>>i);

generate
    begin
    if (FSHW == 2)
        begin: inst_2clkpp
        always @ (wrpnt_bin_n)  wrpnt_bin = wrpnt_bin_n;
        end
    else
        begin: inst_3clkpp
        always @ (posedge rdclk)    wrpnt_bin <= wrpnt_bin_n;
        end
    end
endgenerate

//--------------------------------------------------
reg     [ADDRB:0]   rdpnt_bin= {(ADDRB+1){1'b0}};

wire                fifonemp;
assign              fifonemp    = ~ (wrpnt_bin[ADDRB:0] == rdpnt_bin[ADDRB:0]);

wire                read;
assign              read        = fiford & fifonemp;

wire [ADDRB-1:0]    rdaddr;
assign              rdaddr      = rdpnt_bin[ADDRB-1:0];

wire [ADDRB:0]      rdfifolen;
assign              rdfifolen   = wrpnt_bin[ADDRB:0] - rdpnt_bin[ADDRB:0];

//always @ ( posedge rdclk or negedge rdrst_ )
always @ ( posedge rdclk)
    if(rdrst)
        begin
        rdpnt_bin   <= {(ADDRB+1){1'b0}};
        end
    else
        begin
        if (fifoflush) rdpnt_bin <= {(ADDRB+1){1'b0}};
        else if (read) rdpnt_bin <= rdpnt_bin + 1'b1;      
        end

reg [ADDRB:0]       rdpnt_gray= {(ADDRB+1){1'b0}}; //Gray Encode
//always @ ( posedge rdclk or negedge rdrst_ )
always @ ( posedge rdclk)
    if(rdrst)
        begin
        rdpnt_gray   <= {(ADDRB+1){1'b0}};
        end
    else
        begin
        rdpnt_gray  <= rdpnt_bin ^ {1'b0,rdpnt_bin[ADDRB:1]};
        end

endmodule 
