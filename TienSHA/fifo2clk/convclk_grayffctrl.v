////////////////////////////////////////////////////////////////////////////////
//
// Arrive Technologies
//
// Filename     : convclk_grayffctrl.v
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
//  Sat Nov 03 09:44:11 2012, tund@HW-NDTU
//      Modify flush signal
//  Thu Aug 20 10:16:53 2015, cuongnv@HW-NVCUONG
//      change rst_ to rst
////////////////////////////////////////////////////////////////////////////////

module convclk_grayffctrl
    (
     wrclk,
     rdclk,
     wrrst,
     rdrst,

     fifowr,
     fiford,
     
     fifoflush,
     oflushrd,
     oflushwr,
     
     fifofull,
     half_full,
     fifonemp,

     rdfifolen,
     wrfifolen,
     
     write,
     wraddr,
     read,
     rdaddr
     
     );

////////////////////////////////////////////////////////////////////////////////
// Parameter declarations
parameter   ADDRB = 4;
parameter   LENGTH = 16;
parameter   FSHW = 3;  //normal = 2, improve timing = 3 

////////////////////////////////////////////////////////////////////////////////
// Port declarations
input               wrclk;
input               rdclk;
input               wrrst;
input               rdrst;

input               fifowr;
input               fiford;

input               fifoflush;
output              oflushrd;
output              oflushwr;

output              fifofull;
output              half_full;
output              fifonemp;

output [ADDRB:0]    rdfifolen;
output [ADDRB:0]    wrfifolen;

output              write;
output [ADDRB-1:0]  wraddr;
output              read;
output [ADDRB-1:0]  rdaddr;
////////////////////////////////////////////////////////////////////////////////
// Output declarations


////////////////////////////////////////////////////////////////////////////////
// Local logic and instantiation
wire [ADDRB:0]      wrpnt_gray,rdpnt_gray;

wire [FSHW:0]       fifoflush_c2w_sh;
wire [FSHW:0]       fifoflush_r2w_sh;
wire [FSHW:0]       fifoflush_c2r_sh;
wire                flush_c2w = fifoflush_c2w_sh[FSHW];
wire                flush_r2w = fifoflush_r2w_sh[FSHW];
wire                flush_c2r = fifoflush_c2r_sh[FSHW];
wire                flush_x2w = flush_c2w | flush_r2w;
wire                oflushwr  = flush_x2w;
wire                oflushrd  = flush_c2r;

fflopx #(FSHW+1) flxfifoflush_c2w_sh
    (wrclk,wrrst,{fifoflush_c2w_sh[FSHW-1:0],fifoflush},fifoflush_c2w_sh);

fflopx #(FSHW+1) flxfifoflush_r2w_sh
    (wrclk,wrrst,{fifoflush_r2w_sh[FSHW-1:0],flush_c2r},fifoflush_r2w_sh);

fflopx #(FSHW+1) flxfifoflush_c2r_sh
    (rdclk,rdrst,{fifoflush_c2r_sh[FSHW-1:0],fifoflush},fifoflush_c2r_sh);

convclk_grayffwr #(ADDRB,FSHW)   write_control
    (
     /*AUTOINST*/
     .wrclk                             (wrclk),
     .wrrst                             (wrrst),
     .fifowr                            (fifowr),
     .fifoflush                         (flush_x2w/*fifoflush*/),
     .fifofull                          (fifofull),
     .half_full                         (half_full),
     .wrfifolen                         (wrfifolen),
     .wrpnt_gray                        (wrpnt_gray[ADDRB:0]),
     .write                             (write),
     .wraddr                            (wraddr[ADDRB-1:0]),
     .rdpnt_gray                        (rdpnt_gray[ADDRB:0])
    );

convclk_grayffrd #(ADDRB,FSHW)   read_control
    (
     /*AUTOINST*/
     .rdclk                             (rdclk),
     .rdrst                             (rdrst),
     .fiford                            (fiford),
     .fifoflush                         (flush_c2r/*fifoflush*/),
     .fifonemp                          (fifonemp),
     .rdfifolen                         (rdfifolen),
     .rdpnt_gray                        (rdpnt_gray[ADDRB:0]),
     .read                              (read),
     .rdaddr                            (rdaddr[ADDRB-1:0]),
     .wrpnt_gray                        (wrpnt_gray[ADDRB:0])
    );

endmodule 
