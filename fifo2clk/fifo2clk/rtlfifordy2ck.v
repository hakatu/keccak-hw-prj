////////////////////////////////////////////////////////////////////////////////
//
// Arrive Technologies
//
// Filename     : rtlfifordy2ck.v
// Description  : .FIFO RDY DATAOUT with 2 clock domain
//
// Author       : tund/hungnt
// Created On   : Tue Sep 25 11:25:17 2012
// History (Date, Changed By)
//
////////////////////////////////////////////////////////////////////////////////

module rtlfifordy2ck
    (
    //no need to comment on clock domain
     wrclk,
     wrrst,
     rdclk,
     rdrst,

     // Output interface @rdclk
     fifordy, //that means you can write now
     fifodout, //dout ofc
     fifoget, //read inc, read enable, ...
     fifovld, //data out valid

     // Write interface @wrclk
     fifowr, //write inc, write enable, ...
     fifodi, //din ofc

     // Control/monitor
     flush, //yup, it's flush
     reqen, //don't know, don't use
     fifowrerr, //sim err
     fiforderr, //sim err
     fifofull, //full
     fifolen, //len check
     fifolenrd, //similarly
     fifowa //write address output for error checking
     );

////////////////////////////////////////////////////////////////////////////////
// Parameter declarations

//for fifo input 32*2 to 64 bit data in
parameter           ADD = 7; //800 byte /8 byte per block => 100 address => 128
parameter           LEN = 128; //another word for depth = 2^ADD
parameter           CHK = 2; //error check bit
parameter           WIDTH = 32; //data length
parameter           WIDTH1 = CHK+WIDTH;
parameter           TYPE = "AUTO";
parameter           DUAL_CLK = "ON";
///////////////////////////////////////////////

/*
//for fifo output 32 bit to 32 bit data to hps
parameter           ADD = 6; //max 192 byte /4 byte per block => 48 address => 128
parameter           LEN = 64; //another word for depth = 2^ADD
parameter           CHK = 2; //error check bit
parameter           WIDTH = 32; //data length
parameter           WIDTH1 = CHK+WIDTH;
parameter           TYPE = "AUTO";
parameter           DUAL_CLK = "ON";
///////////////////////////////////////////////
*/

////////////////////////////////////////////////////////////////////////////////
// Port declarations
input               wrclk,
                    wrrst;
input               rdclk,
                    rdrst;

output              fifordy;
output [WIDTH-1:0]  fifodout;
input               fifoget;
output              fifovld;
input               flush;
input               reqen;         
input               fifowr;
input [WIDTH-1:0]   fifodi;

output              fifowrerr;
output              fiforderr;
output              fifofull;
output [ADD:0]      fifolen;
output [ADD:0]      fifolenrd;
output [ADD-1:0]    fifowa;

/*
     // Ram fifo
output              we_fifo;
output [ADD-1:0]    wa_fifo;
output [WIDTH-1:0]  wrd_fifo;
output              re_fifo;
output [ADD-1:0]    ra_fifo;
input [WIDTH-1:0]   rdd_fifo;
*/
////////////////////////////////////////////////////////////////////////////////
// Output declarations

////////////////////////////////////////////////////////////////////////////////
// Local logic and instantiation

// Add by hw-nvcuong
`ifdef  RTLFIFORDY2CK_RAM111
// Store request info into a FIFO
wire                oflushwr,oflushrd;
wire                fiford,notempty,fifofull,fifohfull;
wire                fifowrerr,fiforderr;
wire                we_fifo,re_fifo,re_fifo1;
wire [ADD-1:0]      wa_fifo,ra_fifo,ra_fifo1,ra_fifox;
wire [WIDTH1-1:0]   wrd_fifo,rdd_fifo;
wire [ADD:0]        fifolenx,fifolen;
wire [CHK-1:0]      fifochkwr,fifochkrd,fifochkdout;
wire [ADD-1:0]      fifowa = wa_fifo;
assign              wrd_fifo = {fifochkwr,fifodi};
assign              fifowrerr = fifowr & fifofull;
assign              fifochkwr = wa_fifo[CHK-1:0];

generate
    if (DUAL_CLK == "ON")
        begin: is_dual_clk
convclk_grayffctrl #(ADD,LEN) ififo
    (
     .wrclk     (wrclk),
     .rdclk     (rdclk),
     .wrrst    (wrrst),
     .rdrst    (rdrst),

     .fifowr    (fifowr & (!oflushwr)),
     .fiford    (fiford & (!oflushrd)),
     
     .fifoflush (flush),
     .oflushrd  (oflushrd),
     .oflushwr  (oflushwr),
     
     .fifofull  (fifofull),
     .half_full (fifohfull),
     .fifonemp  (notempty),

     .rdfifolen (fifolenrd),
     .wrfifolen (fifolenx),
     
     .write     (we_fifo),
     .wraddr    (wa_fifo),
     .read      (),
     .rdaddr    (ra_fifo)
     );
iarray111x #(ADD,LEN,WIDTH1,TYPE,0,"OFF",2) imemfifo
    (
     .test      (1'd0),
     .mask      (1'd0),
     .wrst     (wrrst),
     .wclk      (wrclk),
     .wa        (wa_fifo),
     .we        (we_fifo),
     .di        (wrd_fifo),
     .rclk      (rdclk),
     .rrst     (rdrst),
     .re        (re_fifo),
     .ra        (ra_fifox),
     .do        (rdd_fifo)
     );
        
        end
    else
        begin: is_single_clk
fifoc_fshx #(ADD,LEN) ififo
    (
     .clk       (wrclk),
     .rst      (wrrst),
     
     .fiford    (fiford & (!oflushrd)),    // FIFO control
     .fifowr    (fifowr & (!oflushwr)),
     .fifofsh   (flush),   // FIFO flush

     .fifofull  (fifofull),  // high when fifo full
     .notempty  (notempty),  // high when fifo not empty
     .fifolen   (fifolenx),
                // Connect to memories
     .write     (we_fifo),     // enable to write memories
     .wraddr    (wa_fifo),    // write address of memories
     .read      (),
     .rdaddr    (ra_fifo)     // read address of memories
     );
        assign fifolenrd = fifolenx;
        assign oflushrd = flush;
        assign oflushwr = flush;
iarray111x #(ADD,LEN,WIDTH1,TYPE,0,"OFF",1) imemfifo
    (
     .test      (1'd0),
     .mask      (1'd0),
     .wrst     (wrrst),
     .wclk      (wrclk),
     .wa        (wa_fifo),
     .we        (we_fifo),
     .di        (wrd_fifo),
     .rclk      (rdclk),
     .rrst     (rdrst),
     .re        (re_fifo),
     .ra        (ra_fifox),
     .do        (rdd_fifo)
     );
        
        end
endgenerate

////////////////////////////////////////////////////////////////////////////////
// Request outside
wire [2:0]          reqen_sh;
wire [WIDTH-1:0]    fifodout;
reg                 fifordy;
wire                fifoini,fifoini1;
wire                fifowin;
wire                fifovld;
wire                fifored;
reg [1:0]           fifocnt;
wire                fifonxt,fifonxtx;
wire                fifoena;
wire                fifochkerr;
assign              fifochkerr = fifovld && (fifochkdout != fifochkrd);
assign              fiforderr = fifochkerr || fifocnt[1];
assign              fifoena = |fifocnt;
assign              fifovld = fifoget && fifordy;
assign              fifored = ((!fifoget) && fifordy);
assign              fifonxt = (notempty && reqen_sh[2]) && (fifocnt == 2'b00) && fifored;
assign              ra_fifox = fifonxt ? ra_fifo : fifored ? ra_fifo1 : ra_fifo;
assign              re_fifo = (notempty && reqen_sh[2]) || fifored;
assign              fifoini = (notempty && reqen_sh[2]) && ({fifoini1,fifordy,fifonxtx} == 3'b000);
assign              fifowin = (re_fifo1 && fifoena) && (fifovld || fifoini1);
assign              fiford = (notempty && reqen_sh[2]) && (fifowin || fifoini || fifonxt);

always @ (posedge rdclk)
    begin
    if (rdrst) fifocnt <= 2'b0;
    else if (oflushrd) fifocnt <= 2'b0;
    else
        begin
        case ({fiford,fifowin})
            2'b10: fifocnt <= fifocnt + 1'b1;
            2'b01: fifocnt <= fifocnt - 1'b1;
            default:fifocnt <= fifocnt;
        endcase
        end
    end
    
always @ (posedge rdclk)
    begin
    if (rdrst) fifordy <= 1'b0;
    else if (oflushrd) fifordy <= 1'b0; 
    else if (fifowin) fifordy <= 1'b1;
    else if (fifovld) fifordy <= 1'b0;
    end

//assign fifolen = fifolenx + (fifocnt + fifordy);
assign fifolen = fifolenx;
//fflopx #(3) flxreqen_sh (rdclk,rdrst,{reqen_sh[1:0],reqen},reqen_sh[2:0]);
assign reqen_sh = {3{reqen}};
fflopx #(1) flxre_fifo  (rdclk,rdrst,re_fifo,re_fifo1);
fflopxe #(ADD) flxra_fifo  (rdclk,rdrst,fiford,ra_fifo,ra_fifo1);
fflopx #(1) flxfifoini  (rdclk,rdrst,fifoini,fifoini1);
fflopxe #(1) flxfifonxtx  (rdclk,rdrst,oflushrd||fifovld||fifonxt,oflushrd?1'b0:fifonxt,fifonxtx);
fflopxe #(WIDTH1) flxfifodout (rdclk,rdrst,fifowin,rdd_fifo,{fifochkdout,fifodout});
fflopxe #(CHK) flxfifochkrd (rdclk,rdrst,fifovld||oflushrd,oflushrd?{CHK{1'b0}}:fifochkdout+fifovld,fifochkrd);

`else
////////////////////////////////////////////////////////////////////////////////
// Add by hw-nvcuong
// Store request info into a FIFO
wire                oflushwr,oflushrd;
wire                fiford,notempty,fifofull,fifohfull;
wire                fifowrerr,fiforderr;
wire                we_fifo,re_fifo;
wire [ADD-1:0]      wa_fifo,ra_fifo;
wire [WIDTH-1:0]    wrd_fifo,rdd_fifo;
wire [ADD:0]        fifolen;
wire [ADD-1:0]      fifowa = wa_fifo;
assign              wrd_fifo = fifodi;
assign              fifowrerr = fifowr & fifofull;

generate
    if (DUAL_CLK == "ON")
        begin: is_dual_clk
convclk_grayffctrl #(ADD,LEN) ififo
    (
     .wrclk     (wrclk),
     .rdclk     (rdclk),
     .wrrst    (wrrst),
     .rdrst    (rdrst),

     .fifowr    (fifowr & (!oflushwr)),
     .fiford    (fiford & (!oflushrd)),
     
     .fifoflush (flush),
     .oflushrd  (oflushrd),
     .oflushwr  (oflushwr),
     
     .fifofull  (fifofull),
     .half_full (fifohfull),
     .fifonemp  (notempty),

     .rdfifolen (fifolenrd),
     .wrfifolen (fifolen),
     
     .write     (we_fifo),
     .wraddr    (wa_fifo),
     .read      (re_fifo),
     .rdaddr    (ra_fifo)
     );
iarray113x #(ADD,LEN,WIDTH,TYPE,0,"OFF",2) imemfifo
    (
     .test      (1'd0),
     .mask      (1'd0),
     .wrst     (wrrst),
     .wclk      (wrclk),
     .wa        (wa_fifo),
     .we        (we_fifo),
     .di        (wrd_fifo),
     .rclk      (rdclk),
     .rrst     (rdrst),
     .re        (re_fifo),
     .ra        (ra_fifo),
     .do        (rdd_fifo)
     );
        
        end
    else
        begin: is_single_clk
fifoc_fshx #(ADD,LEN) ififo
    (
     .clk       (wrclk),
     .rst      (wrrst),
     
     .fiford    (fiford & (!oflushrd)),    // FIFO control
     .fifowr    (fifowr & (!oflushwr)),
     .fifofsh   (flush),   // FIFO flush

     .fifofull  (fifofull),  // high when fifo full
     .notempty  (notempty),  // high when fifo not empty
     .fifolen   (fifolen),
                // Connect to memories
     .write     (we_fifo),     // enable to write memories
     .wraddr    (wa_fifo),    // write address of memories
     .read      (re_fifo),
     .rdaddr    (ra_fifo)     // read address of memories
     );
        assign fifolenrd = fifolen;
        assign oflushrd = flush;
        assign oflushwr = flush;
iarray113x #(ADD,LEN,WIDTH,TYPE,0,"OFF",1) imemfifo
    (
     .test      (1'd0),
     .mask      (1'd0),
     .wrst     (wrrst),
     .wclk      (wrclk),
     .wa        (wa_fifo),
     .we        (we_fifo),
     .di        (wrd_fifo),
     .rclk      (rdclk),
     .rrst     (rdrst),
     .re        (re_fifo),
     .ra        (ra_fifo),
     .do        (rdd_fifo)
     );
        
        end
endgenerate


////////////////////////////////////////////////////////////////////////////////
// Read RAM and store to a register FIFO to request clock by clock
// This logic refer to fifoc_anylenx.v on atvn/lib_v/macro
reg             flushrd = 1'b1;
always @ (posedge rdclk)
    begin
    if (rdrst)      flushrd <= 1'b1;
    else            flushrd <= oflushrd;
    end

reg                 fiford1 = 1'b0;
reg                 fiford2 = 1'b0;
reg                 fiford3 = 1'b0;
always @ (posedge rdclk)
    begin
    if (flushrd)    {fiford1,fiford2,fiford3} <= 3'd0;
    else            {fiford1,fiford2,fiford3} <= {fiford,fiford1,fiford2};
    end

reg [WIDTH-1:0] reqfifo0 = {WIDTH{1'b0}};
reg [WIDTH-1:0] reqfifo1 = {WIDTH{1'b0}};
reg [WIDTH-1:0] reqfifo2 = {WIDTH{1'b0}};
reg [WIDTH-1:0] reqfifo3 = {WIDTH{1'b0}};
reg [WIDTH-1:0] reqfifo4 = {WIDTH{1'b0}};
parameter       LENGTH = 4'd5;

reg [3:0]       reqlen = 4'd0;
reg [2:0]       reqrdcnt = 3'd0;

wire [3:0]      sumcnt;
assign          sumcnt = reqrdcnt + reqlen;
wire [3:0]      over;
assign          over = sumcnt - LENGTH;
wire [2:0]      reqwrcnt;
assign          reqwrcnt = over[3] ? sumcnt[2:0] : over[2:0];

wire            reqnemp;
assign          reqnemp = (|reqlen) & reqen;

wire            checklen;
assign          checklen = reqlen == LENGTH;

wire            reqread;
//assign          reqread = reqnempt & reqffrd;

wire            reqfull;
assign          reqfull = reqlen[3] | checklen;

wire            reqwrite;
//assign        reqwrite = fifowr & (~full);
assign          reqwrite = fiford3 & (~reqfull);

wire            reqwerr;
assign          reqwerr = fiford3 & reqfull;

wire [2:0]      reqrdcntmax;
assign          reqrdcntmax = LENGTH - 1'b1;

wire            reqrdcntcry;
assign          reqrdcntcry = reqrdcnt == reqrdcntmax;

always @(posedge rdclk)
    begin
    if (flushrd)        reqrdcnt <= {3{1'b0}};
    else if (reqread)   reqrdcnt <= reqrdcntcry ? {3{1'b0}} : reqrdcnt + 1'b1;
    end

always @(posedge rdclk)
    begin
    if (flushrd) reqlen <= {1'b0,{3{1'b0}}};
    else 
        begin
        case ({reqread,reqwrite})
            2'b01: reqlen <= reqlen + 1'b1;
            2'b10: reqlen <= reqlen - 1'b1;
            default:    reqlen <= reqlen;
        endcase
        end
    end

always @ (posedge rdclk)
    begin
    if  (reqwrite & (reqwrcnt == 3'd0)) reqfifo0 <= rdd_fifo;
    if  (reqwrite & (reqwrcnt == 3'd1)) reqfifo1 <= rdd_fifo;
    if  (reqwrite & (reqwrcnt == 3'd2)) reqfifo2 <= rdd_fifo;
    if  (reqwrite & (reqwrcnt == 3'd3)) reqfifo3 <= rdd_fifo;
    if  (reqwrite & (reqwrcnt == 3'd4)) reqfifo4 <= rdd_fifo;
    end

reg             fifordy = 1'b0;
always @ (posedge rdclk)
    begin
    if (flushrd)    fifordy <= 1'd0;
    else            fifordy <= reqnemp | (!fifoget & fifordy);
    end

assign          reqread = reqnemp & (!fifordy | fifoget);

reg [WIDTH-1:0]  fifodout = {WIDTH{1'b0}};
always @ (posedge rdclk)
    begin
    if (reqread)
        begin
        case (reqrdcnt)
            3'd0:       fifodout <= reqfifo0;
            3'd1:       fifodout <= reqfifo1;
            3'd2:       fifodout <= reqfifo2;
            3'd3:       fifodout <= reqfifo3;
            default:    fifodout <= reqfifo4;
        endcase     
        end
    else        fifodout <= fifodout;
    end

wire            fifovld;
assign          fifovld = fifoget && fifordy;
assign          fiforderr = !fifordy && fifoget;

// FIFO len for flow control
reg [3:0]       reqwrlen = 4'd0;
wire            reqwrfull;
assign          reqwrfull = reqwrlen[3] | (reqwrlen == LENGTH);
assign          fiford = notempty & (!reqwrfull);

always @(posedge rdclk)
    begin
    if (flushrd) reqwrlen <= {1'b0,{3{1'b0}}};
    else 
        begin
        case ({reqread,fiford})
            2'b01: reqwrlen <= reqwrlen + 1'b1;
            2'b10: reqwrlen <= reqwrlen - 1'b1;
            default: reqwrlen <= reqwrlen;
        endcase
        end
    end

`endif  //`ifdef  RTLFIFORDY2CK_RAM111

////////////////////////////////////////////////////////////////////////////////
`ifdef RTL_DTU_DEBUG
always @ (posedge wrclk)
    begin
    if (fifowrerr) $display ("%m | FIFO_WR_ERROR",$time);
    end                           
`endif

always @ (posedge rdclk)
    begin
    if (fiforderr) $display ("%m | FIFO_RD_ERROR",$time);
    end
endmodule 
